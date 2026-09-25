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
        # A stub returned by a previous execution can be passed back to be
        # reconfigured in place instead of registering another stub.
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
        # message_expectation = executor.execute
        #
        # # After configs change
        # executor.execute(message_expectation)
        # executor.update_arguments(message_expectation)
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

          # Registers the stub, or reconfigures the stub from a previous execution.
          #
          # Validates all configs first, then applies the argument matcher and
          # the appropriate return behavior (single or sequential).
          #
          # @param message_expectation [RSpec::Mocks::MessageExpectation, nil] Stub to reconfigure
          # @return [RSpec::Mocks::MessageExpectation] The configured stub
          # @raise [ArgumentError] If any config is invalid
          def execute(message_expectation = nil)
            validate_configs!

            message_expectation = stub_or_update_arguments(message_expectation)

            if sequential?
              apply_sequential_behavior(message_expectation)
            else
              apply_return_behavior(message_expectation, @configs.first)
            end

            message_expectation
          end

          # Replaces the argument matcher of a registered stub.
          #
          # @param message_expectation [RSpec::Mocks::MessageExpectation] Stub to update
          # @return [RSpec::Mocks::MessageExpectation] The updated stub
          def update_arguments(message_expectation)
            message_expectation.with(argument_matcher)
          end

          private

          # Checks if this is a sequential mock (multiple configs).
          #
          # @return [Boolean] True if more than one config
          def sequential?
            @configs.size > 1
          end

          # Registers a new stub or updates the arguments of an existing one.
          #
          # @param message_expectation [RSpec::Mocks::MessageExpectation, nil] Existing stub
          # @return [RSpec::Mocks::MessageExpectation] The stub constrained by the argument matcher
          def stub_or_update_arguments(message_expectation)
            return update_arguments(message_expectation) unless message_expectation.nil?

            @rspec_context.allow(@service_class).to(
              @rspec_context.receive(@configs.first.method_type).with(argument_matcher)
            )
          end

          # Builds the argument matcher shared by all configs.
          #
          # @return [Object] RSpec argument matcher
          def argument_matcher
            @configs.first.build_argument_matcher(@rspec_context)
          end

          # Applies sequential return behavior to a message expectation.
          #
          # Uses and_return for simple returns and and_invoke when
          # exceptions need to be raised.
          #
          # @param message_expectation [RSpec::Mocks::MessageExpectation] The stub to configure
          # @return [void]
          def apply_sequential_behavior(message_expectation)
            if all_returns?
              message_expectation.and_return(*@configs.map(&:build_result))
            else
              message_expectation.and_invoke(*@configs.map { |config| build_callable(config) })
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
              message_expectation.and_wrap_original(&wrap_with_keyword_inputs(config.wrap_block))
            elsif config.failure? && config.bang_method?
              message_expectation.and_raise(config.exception)
            else
              message_expectation.and_return(config.build_result)
            end
          end

          # Adapts a wrap block to receive service inputs as keywords.
          #
          # Services accept inputs as keywords or as a positional Hash,
          # the wrap block receives them as keywords in both cases.
          #
          # @param wrap_block [Proc] Block given to and_wrap_original
          # @return [Proc] Block for RSpec's and_wrap_original
          def wrap_with_keyword_inputs(wrap_block)
            lambda do |original, *arguments, &block|
              if arguments.one? && arguments.first.is_a?(Hash)
                wrap_block.call(original, **arguments.first, &block)
              else
                wrap_block.call(original, *arguments, &block)
              end
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
