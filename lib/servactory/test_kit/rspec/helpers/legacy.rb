# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        # Backward-compatible API for mocking Servactory services in RSpec tests.
        #
        # ## Purpose
        #
        # Provides legacy helper methods for mocking Servactory service calls.
        # These methods are maintained for backward compatibility with existing tests.
        # For new tests, consider using the fluent API via {Fluent} module.
        #
        # ## Usage
        #
        # Include in RSpec configuration via the main Helpers module:
        #
        # ```ruby
        # RSpec.configure do |config|
        #   config.include Servactory::TestKit::Rspec::Helpers, type: :service
        # end
        # ```
        #
        # ## Available Methods
        #
        # - `allow_service_as_success!` - mock `.call!` method for success
        # - `allow_service_as_success` - mock `.call` method for success
        # - `allow_service_as_failure!` - mock `.call!` method for failure
        # - `allow_service_as_failure` - mock `.call` method for failure
        #
        # ## Examples
        #
        # ```ruby
        # # Mock call method (returns Result)
        # allow_service_as_success(PaymentService) do
        #   { transaction_id: "txn_123" }
        # end
        #
        # # Mock call! method (raises on failure)
        # allow_service_as_success!(PaymentService, with: { amount: 100 }) do
        #   { transaction_id: "txn_123" }
        # end
        #
        # # Mock failure
        # allow_service_as_failure(PaymentService) do
        #   {
        #     exception: ApplicationService::Exceptions::Failure.new(
        #       type: :base,
        #       message: "Failed"
        #     )
        #   }
        # end
        # ```
        #
        # @see Fluent for the recommended fluent API
        module Legacy
          # Mock the `call!` method to return a successful result.
          #
          # @param service_class [Class] The service class to mock
          # @param with [Hash, nil] Expected arguments matcher
          # @yield Block returning Hash of output attributes
          # @return [void]
          #
          # @example Basic success mock
          #   allow_service_as_success!(PaymentService) do
          #     { transaction_id: "txn_123" }
          #   end
          #
          # @example With argument matcher
          #   allow_service_as_success!(PaymentService, with: { amount: 100 }) do
          #     { transaction_id: "txn_123" }
          #   end
          #
          def allow_service_as_success!(service_class, with: nil, &block)
            allow_service_legacy!(service_class, :as_success, with:, &block)
          end

          # Mock the `call` method to return a successful result.
          #
          # @param service_class [Class] The service class to mock
          # @param with [Hash, nil] Expected arguments matcher
          # @yield Block returning Hash of output attributes
          # @return [void]
          #
          # @example Basic success mock
          #   allow_service_as_success(PaymentService) do
          #     { transaction_id: "txn_123" }
          #   end
          #
          def allow_service_as_success(service_class, with: nil, &block)
            allow_service_legacy(service_class, :as_success, with:, &block)
          end

          # Mock the `call!` method to raise a failure exception.
          #
          # @param service_class [Class] The service class to mock
          # @param with [Hash, nil] Expected arguments matcher
          # @yield Block returning an exception or Hash with `:exception` key
          # @return [void]
          #
          # @example Failure mock
          #   allow_service_as_failure!(PaymentService) do
          #     ApplicationService::Exceptions::Failure.new(
          #       type: :payment_declined,
          #       message: "Card declined"
          #     )
          #   end
          #
          def allow_service_as_failure!(service_class, with: nil, &block)
            allow_service_legacy!(service_class, :as_failure, with:, &block)
          end

          # Mock the `call` method to return a failure result.
          #
          # @param service_class [Class] The service class to mock
          # @param with [Hash, nil] Expected arguments matcher
          # @yield Block returning an exception or Hash with `:exception` key
          # @return [void]
          #
          # @example Failure mock with exception in hash
          #   allow_service_as_failure(PaymentService) do
          #     {
          #       exception: ApplicationService::Exceptions::Failure.new(
          #         type: :base,
          #         message: "Failed"
          #       )
          #     }
          #   end
          #
          def allow_service_as_failure(service_class, with: nil, &block)
            allow_service_legacy(service_class, :as_failure, with:, &block)
          end

          private

          # Builds legacy mock for .call! method.
          #
          # @param service_class [Class] The service class to mock
          # @param result_type [Symbol] :as_success or :as_failure
          # @param with [Hash, nil] Argument matcher
          # @return [void]
          def allow_service_legacy!(service_class, result_type, with: nil, &block)
            allow_servactory_legacy(service_class, :call!, result_type, with:, &block)
          end

          # Builds legacy mock for .call method.
          #
          # @param service_class [Class] The service class to mock
          # @param result_type [Symbol] :as_success or :as_failure
          # @param with [Hash, nil] Argument matcher
          # @return [void]
          def allow_service_legacy(service_class, result_type, with: nil, &block)
            allow_servactory_legacy(service_class, :call, result_type, with:, &block)
          end

          # Core legacy mock implementation.
          #
          # @param service_class [Class] The service class to mock
          # @param method_call [Symbol] :call or :call!
          # @param result_type [Symbol] :as_success or :as_failure
          # @param with [Hash, nil] Argument matcher
          # @return [void]
          def allow_servactory_legacy(service_class, method_call, result_type, with: nil)
            config = build_legacy_config(service_class, method_call, result_type, with, block_given? ? yield : nil)

            Helpers::MockExecutor.new(
              service_class:,
              configs: [config],
              rspec_context: self
            ).execute
          end

          # Builds ServiceMockConfig from legacy parameters.
          #
          # @param service_class [Class] The service class
          # @param method_call [Symbol] :call or :call!
          # @param result_type [Symbol] :as_success or :as_failure
          # @param with_arg [Hash, nil] Argument matcher
          # @param block_result [Hash, Object, nil] Block return value
          # @return [ServiceMockConfig] Configured mock config
          def build_legacy_config(service_class, method_call, result_type, with_arg, block_result)
            config = Helpers::ServiceMockConfig.new(service_class:)
            config.method_type = method_call.to_sym
            config.result_type = result_type == :as_success ? :success : :failure
            config.argument_matcher = with_arg

            process_legacy_block_result(config, block_result) if block_result

            config
          end

          # Processes block result into config outputs/exception.
          #
          # @param config [ServiceMockConfig] The config to update
          # @param block_result [Hash, Object] Block return value
          # @return [void]
          def process_legacy_block_result(config, block_result) # rubocop:disable Metrics/MethodLength
            validate_legacy_block_result!(block_result, config.success?)

            if block_result.is_a?(Hash)
              if config.success?
                config.outputs = block_result
              else
                config.exception = block_result[:exception] if block_result[:exception]
                config.outputs = block_result.except(:exception)
              end
            else
              config.exception = block_result
            end
          end

          # Validates block result format for legacy API.
          #
          # @param block_result [Object] The block return value
          # @param is_success [Boolean] Whether this is a success mock
          # @raise [ArgumentError] If success mock block doesn't return Hash
          # @return [void]
          def validate_legacy_block_result!(block_result, is_success)
            return unless is_success && !block_result.is_a?(Hash)

            raise ArgumentError, "Invalid value for block. Must be a Hash with attributes."
          end
        end
      end
    end
  end
end
