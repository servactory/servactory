# frozen_string_literal: true

require_relative "helpers/concerns/error_messages"
require_relative "helpers/concerns/service_class_validation"
require_relative "helpers/service_mock_config"
require_relative "helpers/mock_executor"
require_relative "helpers/output_validator"
require_relative "helpers/argument_matchers"
require_relative "helpers/service_mock_builder"
require_relative "helpers/service_expectation_builder"

module Servactory
  module TestKit
    module Rspec
      module Helpers
        include Helpers::ArgumentMatchers

        # ============================================================
        # New Fluent API
        # ============================================================

        # Start building a service mock with fluent API
        #
        # @param service_class [Class] The service class to mock
        # @return [ServiceMockBuilder] Builder for fluent configuration
        #
        # @example Success mock
        #   allow_service(PaymentService)
        #     .as_success
        #     .with_outputs(transaction_id: "txn_123")
        #     .when_called_with(amount: 100)
        #
        # @example Failure mock
        #   allow_service(PaymentService)
        #     .as_failure
        #     .with_exception(PaymentError.new("Declined"))
        #
        # @example Sequential returns
        #   allow_service(PaymentService)
        #     .as_success.with_outputs(status: :pending)
        #     .then_as_success.with_outputs(status: :completed)
        #
        def mock_service(service_class)
          Helpers::ServiceMockBuilder.new(service_class, rspec_context: self)
        end

        # Start building a service expectation (spy) with fluent API
        #
        # @param service_class [Class] The service class to verify
        # @return [ServiceExpectationBuilder] Builder for verification
        #
        # @example Verify call count
        #   expect_service(PaymentService)
        #     .as_success
        #     .to_have_been_called.once
        #     .with(amount: 100)
        #
        def expect_service(service_class)
          Helpers::ServiceExpectationBuilder.new(service_class, rspec_context: self)
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

        # ============================================================
        # Legacy Implementation (Internal methods for backward compat)
        # ============================================================

        def allow_service_legacy!(service_class, result_type, with: nil, &block)
          allow_servactory_legacy(service_class, :call!, result_type, with:, &block)
        end

        def allow_service_legacy(service_class, result_type, with: nil, &block)
          allow_servactory_legacy(service_class, :call, result_type, with:, &block)
        end

        def allow_servactory_legacy(service_class, method_call, result_type, with: nil)
          config = build_legacy_config(service_class, method_call, result_type, with, block_given? ? yield : nil)

          Helpers::MockExecutor.new(
            service_class:,
            configs: [config],
            rspec_context: self
          ).execute
        end

        def build_legacy_config(service_class, method_call, result_type, with_arg, block_result)
          config = Helpers::ServiceMockConfig.new(service_class:)
          config.method_type = method_call.to_sym
          config.result_type = result_type == :as_success ? :success : :failure
          config.argument_matcher = with_arg

          process_legacy_block_result(config, block_result) if block_result

          config
        end

        def process_legacy_block_result(config, block_result)
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

        def validate_legacy_block_result!(block_result, is_success)
          return unless is_success && !block_result.is_a?(Hash)

          raise ArgumentError, "Invalid value for block. Must be a Hash with attributes."
        end
      end
    end
  end
end
