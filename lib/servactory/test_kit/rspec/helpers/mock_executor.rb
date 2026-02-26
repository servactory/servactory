# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        # Executes RSpec stubbing based on mock configurations.
        #
        # ## Purpose
        #
        # MockExecutor translates ServiceMockConfig objects into actual RSpec
        # stub setups using `allow(...).to receive(...)`. It handles single
        # and sequential call scenarios, applying appropriate return behaviors.
        #
        # ## Usage
        #
        # Typically used internally by ServiceMockBuilder:
        #
        # ```ruby
        # executor = MockExecutor.new(
        #   service_class: MyService,
        #   configs: [config1, config2],
        #   rspec_context: self
        # )
        # executor.execute
        # ```
        #
        # ## Execution Strategies
        #
        # - **Single Config** - uses `and_return` or `and_raise` directly
        # - **Sequential Returns** - uses `and_return(*values)` for multiple values
        # - **Sequential with Raises** - uses `and_invoke(*callables)` for mixed behavior
        #
        # ## Architecture
        #
        # Works with:
        # - ServiceMockConfig - provides configuration for each stub
        # - ServiceMockBuilder - creates executor with configs
        # - RSpec Context - provides allow/receive/etc. methods
        class MockExecutor
          include Concerns::ErrorMessages

          # Creates a new mock executor.
          #
          # @param service_class [Class] The Servactory service class to stub
          # @param configs [Array<ServiceMockConfig>] Configurations for each call
          # @param rspec_context [Object] RSpec example context with stubbing methods
          def initialize(service_class:, configs:, rspec_context:)
            @service_class = service_class
            @configs = configs
            @rspec_context = rspec_context
          end

          # Executes the stub setup based on configurations.
          #
          # Validates all configs first, then applies appropriate stubbing
          # strategy (single or sequential).
          #
          # @return [void]
          # @raise [ArgumentError] If any config is invalid
          def execute
            validate_configs!

            if sequential?
              execute_sequential
            else
              execute_single
            end
          end

          private

          # Checks if this is a sequential mock (multiple configs).
          #
          # @return [Boolean] True if more than one config
          def sequential?
            @configs.size > 1
          end

          # Executes a single-config stub.
          #
          # @return [void]
          def execute_single
            config = @configs.first
            method_name = config.method_type
            arg_matcher = config.build_argument_matcher(@rspec_context)

            message_expectation = @rspec_context.allow(@service_class).to(
              @rspec_context.receive(method_name).with(arg_matcher)
            )

            apply_return_behavior(message_expectation, config)
          end

          # Executes a multi-config sequential stub.
          #
          # Chooses between and_return (for simple returns) and and_invoke
          # (when exceptions need to be raised).
          #
          # @return [void]
          def execute_sequential
            method_name = @configs.first.method_type
            arg_matcher = @configs.first.build_argument_matcher(@rspec_context)

            if all_returns?
              execute_sequential_returns(method_name, arg_matcher)
            else
              execute_sequential_invoke(method_name, arg_matcher)
            end
          end

          # Checks if all configs can use simple and_return.
          #
          # Returns false if any config is a failure with bang method,
          # which requires raising an exception.
          #
          # @return [Boolean] True if all configs are simple returns
          def all_returns?
            @configs.none? { |config| config.failure? && config.bang_method? }
          end

          # Executes sequential stub with and_return for all values.
          #
          # @param method_name [Symbol] The method being stubbed
          # @param arg_matcher [Object] RSpec argument matcher
          # @return [void]
          def execute_sequential_returns(method_name, arg_matcher)
            returns = @configs.map(&:build_result)

            @rspec_context.allow(@service_class).to(
              @rspec_context.receive(method_name)
                .with(arg_matcher)
                .and_return(*returns)
            )
          end

          # Executes sequential stub with and_invoke for mixed behavior.
          #
          # Uses callables to handle both returns and raises.
          #
          # @param method_name [Symbol] The method being stubbed
          # @param arg_matcher [Object] RSpec argument matcher
          # @return [void]
          def execute_sequential_invoke(method_name, arg_matcher)
            callables = @configs.map { |config| build_callable(config) }

            @rspec_context.allow(@service_class).to(
              @rspec_context.receive(method_name)
                .with(arg_matcher)
                .and_invoke(*callables)
            )
          end

          # Builds a callable lambda for and_invoke.
          #
          # @param config [ServiceMockConfig] The config to build callable for
          # @return [Proc] Lambda that returns result or raises exception
          def build_callable(config)
            if config.failure? && config.bang_method?
              ->(*_args) { raise config.exception }
            else
              result = config.build_result
              ->(*_args) { result }
            end
          end

          # Applies return or raise behavior to a message expectation.
          #
          # @param message_expectation [Object] RSpec message expectation
          # @param config [ServiceMockConfig] Configuration with result/exception
          # @return [void]
          def apply_return_behavior(message_expectation, config)
            if config.call_original?
              message_expectation.and_call_original
            elsif config.wrap_original?
              message_expectation.and_wrap_original(&config.wrap_block)
            elsif config.failure? && config.bang_method?
              message_expectation.and_raise(config.exception)
            else
              message_expectation.and_return(config.build_result)
            end
          end

          # Validates all configurations before executing.
          #
          # @return [void]
          # @raise [ArgumentError] If any config is invalid
          def validate_configs!
            @configs.each { |config| validate_config!(config) }
          end

          # Validates a single configuration.
          #
          # @param config [ServiceMockConfig] The config to validate
          # @return [void]
          # @raise [ArgumentError] If config is invalid
          def validate_config!(config)
            validate_failure_has_exception!(config)
            validate_exception_type!(config)
          end

          # Validates that failure configs have an exception.
          #
          # @param config [ServiceMockConfig] The config to validate
          # @return [void]
          # @raise [ArgumentError] If failure config is missing exception
          def validate_failure_has_exception!(config)
            return unless config.failure? && config.exception.nil?

            raise ArgumentError, missing_exception_for_failure_message(config.service_class)
          end

          # Validates that exception is the correct type for the service.
          #
          # @param config [ServiceMockConfig] The config to validate
          # @return [void]
          # @raise [ArgumentError] If exception type is wrong
          def validate_exception_type!(config)
            return if config.exception.nil?
            return if valid_exception_type?(config)

            raise ArgumentError, invalid_exception_type_message(
              service_class: config.service_class,
              expected_class: failure_class_for(config),
              actual_class: config.exception.class
            )
          end

          # Checks if exception is the correct type.
          #
          # Uses different validation strategies based on method type:
          # - For `.call` (non-bang): Relaxed validation - accepts any Servactory::Exceptions::Failure subclass
          #   because the exception is wrapped in Result and never raised, so type doesn't matter.
          # - For `.call!` (bang): Strict validation - requires the service's configured failure_class
          #   because the exception IS raised and type matters for rescue clauses.
          #
          # @param config [ServiceMockConfig] The config to check
          # @return [Boolean] True if exception is valid type
          def valid_exception_type?(config)
            if config.bang_method?
              # Strict validation for call! - exception will be raised
              config.exception.is_a?(failure_class_for(config))
            else
              # Relaxed validation for call - exception is only wrapped in Result
              config.exception.is_a?(Servactory::Exceptions::Failure)
            end
          end

          # Returns the expected failure class for a service.
          #
          # @param config [ServiceMockConfig] The config with service class
          # @return [Class] The service's failure class
          def failure_class_for(config)
            config.service_class.config.failure_class
          end
        end
      end
    end
  end
end
