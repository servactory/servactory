# frozen_string_literal: true

require_relative "helpers/concerns/error_messages"
require_relative "helpers/concerns/service_class_validation"
require_relative "helpers/service_mock_config"
require_relative "helpers/mock_executor"
require_relative "helpers/input_validator"
require_relative "helpers/output_validator"
require_relative "helpers/argument_matchers"
require_relative "helpers/service_mock_builder"

module Servactory
  module TestKit
    module Rspec
      # RSpec helper methods for mocking Servactory services.
      #
      # ## Purpose
      #
      # Provides convenient helper methods for mocking Servactory service calls
      # in RSpec tests. Supports both a modern fluent API and backward-compatible
      # legacy methods.
      #
      # ## Usage
      #
      # Include in RSpec configuration:
      #
      # ```ruby
      # RSpec.configure do |config|
      #   config.include Servactory::TestKit::Rspec::Helpers, type: :service
      # end
      # ```
      #
      # ## Available Helpers
      #
      # **Fluent API (recommended):**
      # - `allow_service(ServiceClass)` - mock `.call` method (returns Result)
      # - `allow_service!(ServiceClass)` - mock `.call!` method (raises on failure)
      #
      # **Backward-Compatible API:**
      # - `allow_service_as_success!` / `allow_service_as_success`
      # - `allow_service_as_failure!` / `allow_service_as_failure`
      #
      # **Argument Matchers:**
      # - `including(hash)` - partial hash matching
      # - `excluding(hash)` - exclusion matching
      # - `any_inputs` - match any arguments
      # - `no_inputs` - match no arguments
      module Helpers
        include Helpers::ArgumentMatchers

        # ============================================================
        # New Fluent API
        # ============================================================

        # Start building a service mock with fluent API for .call method.
        #
        # When service fails, returns Result with `.error` attribute.
        #
        # @param service_class [Class] The service class to mock
        # @return [ServiceMockBuilder] Builder for fluent configuration
        #
        # @example Success mock
        #   allow_service(PaymentService)
        #     .succeeds(transaction_id: "txn_123", status: :completed)
        #
        # @example Success with input matching
        #   allow_service(PaymentService)
        #     .with(amount: 100)
        #     .succeeds(transaction_id: "txn_123")
        #
        # @example Failure mock
        #   allow_service(PaymentService)
        #     .fails(message: "Card declined", type: :payment_declined)
        #
        # @example Sequential returns
        #   allow_service(PaymentService)
        #     .succeeds(status: :pending)
        #     .then_succeeds(status: :completed)
        #     .then_fails(message: "Request timed out", type: :timeout)
        #
        def allow_service(service_class)
          Helpers::ServiceMockBuilder.new(service_class, method_type: :call, rspec_context: self)
        end

        # Start building a service mock with fluent API for .call! method.
        #
        # When service fails, raises exception.
        #
        # @param service_class [Class] The service class to mock
        # @return [ServiceMockBuilder] Builder for fluent configuration
        #
        # @example Success mock for call!
        #   allow_service!(PaymentService)
        #     .succeeds(transaction_id: "txn_123", status: :completed)
        #
        # @example Failure mock for call! (raises exception)
        #   allow_service!(PaymentService)
        #     .fails(message: "Insufficient funds", type: :payment_declined)
        #
        # @example Sequential returns
        #   allow_service!(RetryService)
        #     .succeeds(status: :pending)
        #     .then_fails(message: "Request timed out", type: :timeout)
        #
        def allow_service!(service_class)
          Helpers::ServiceMockBuilder.new(service_class, method_type: :call!, rspec_context: self)
        end

        # ============================================================
        # Backward-Compatible API (Existing Methods)
        # ============================================================

        # Mock the `call!` method to return a successful result
        #
        # @param service_class [Class] The service class to mock
        # @param with [Hash, nil] Expected arguments matcher
        # @yield Block returning Hash of output attributes
        #
        def allow_service_as_success!(service_class, with: nil, &block)
          allow_service_legacy!(service_class, :as_success, with:, &block)
        end

        # Mock the `call` method to return a successful result
        #
        # @param service_class [Class] The service class to mock
        # @param with [Hash, nil] Expected arguments matcher
        # @yield Block returning Hash of output attributes
        #
        def allow_service_as_success(service_class, with: nil, &block)
          allow_service_legacy(service_class, :as_success, with:, &block)
        end

        # Mock the `call!` method to raise a failure exception
        #
        # @param service_class [Class] The service class to mock
        # @param with [Hash, nil] Expected arguments matcher
        # @yield Block returning an exception or Hash with `:exception` key
        #
        def allow_service_as_failure!(service_class, with: nil, &block)
          allow_service_legacy!(service_class, :as_failure, with:, &block)
        end

        # Mock the `call` method to return a failure result
        #
        # @param service_class [Class] The service class to mock
        # @param with [Hash, nil] Expected arguments matcher
        # @yield Block returning an exception or Hash with `:exception` key
        #
        def allow_service_as_failure(service_class, with: nil, &block)
          allow_service_legacy(service_class, :as_failure, with:, &block)
        end

        private

        # Legacy Implementation
        # ---------------------

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
