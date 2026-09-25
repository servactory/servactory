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
        # reconfigured in place instead of registering another stub, as long
        # as it has not been invoked.
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
        # stub = executor.execute
        #
        # # After configs change, while the stub has not been invoked
        # executor.execute(stub)
        # executor.update_arguments(stub)
        # ```
        #
        # ## Argument Matching
        #
        # - **With `.with()`** - RSpec matches the arguments against the configured matcher
        # - **Without `.with()`** - RSpec accepts any arguments, and ServiceInputsGuard
        #   verifies them against the service inputs before the stub responds
        #
        # ## Execution Strategies
        #
        # - **Single Config** - uses `and_return` or `and_raise` directly
        # - **Pass-Through** - uses `and_wrap_original` to call the original or the wrap block
        # - **Sequential Returns** - uses `and_return(*values)` for multiple values
        # - **Sequential with Raises** - uses `and_invoke(*callables)` for mixed behavior
        #
        # ## Architecture
        #
        # Works with:
        # - ServiceMockConfig - provides configuration for each stub
        # - ServiceMockBuilder - creates executor with configs
        # - ExceptionValidator - validates exceptions of the configs
        # - ServiceInputsGuard - verifies inputs of calls accepted with any arguments
        # - WrapBlockAdapter - adapts wrap blocks to the arguments of service calls
        # - RSpec Context - provides allow/receive/etc. methods
        class MockExecutor
          # Registered RSpec stub and the guard verifying the inputs it receives.
          #
          # @!attribute [r] message_expectation
          #   @return [RSpec::Mocks::MessageExpectation] The RSpec stub
          # @!attribute [r] inputs_guard
          #   @return [ServiceInputsGuard] The guard called by the stub implementation
          Stub = Data.define(:message_expectation, :inputs_guard) do
            # Checks whether the stub has received a call.
            #
            # RSpec does not allow modifying an invoked stub.
            #
            # @return [Boolean] True if the stub has been invoked
            def invoked?
              inputs_guard.invoked?
            end
          end

          CALL_ORIGINAL = lambda do |original, *arguments, &block|
            original.call(*arguments, &block)
          end.ruby2_keywords

          private_constant :CALL_ORIGINAL

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
          # @param stub [Stub, nil] Stub to reconfigure, which must not have been invoked
          # @return [Stub] The configured stub
          # @raise [ArgumentError] If any config is invalid
          def execute(stub = nil)
            validate_configs!

            stub = stub.nil? ? register_stub : update_arguments(stub)

            if sequential?
              apply_sequential_behavior(stub.message_expectation)
            else
              apply_return_behavior(stub, @configs.first)
            end

            stub
          end

          # Replaces the argument matcher of a registered stub
          # and the inputs matcher of its guard.
          #
          # @param stub [Stub] Stub to update, which must not have been invoked
          # @return [Stub] The updated stub
          def update_arguments(stub)
            stub.message_expectation.with(argument_matcher)
            stub.inputs_guard.inputs_matcher = @configs.first.build_inputs_matcher
            stub
          end

          private

          # Checks if this is a sequential mock (multiple configs).
          #
          # @return [Boolean] True if more than one config
          def sequential?
            @configs.size > 1
          end

          # Registers a new stub constrained by the argument matcher.
          #
          # Return behaviors run after the guard, which is registered as the stub
          # implementation. Pass-through behaviors replace the stub implementation,
          # so they call the guard themselves.
          #
          # @return [Stub] The registered stub
          def register_stub
            inputs_guard = ServiceInputsGuard.new(service_class: @service_class, method_type:)
            implementation = ->(*arguments) { inputs_guard.verify!(arguments) } unless @configs.first.pass_through?

            message_expectation = @rspec_context.allow(@service_class).to(
              @rspec_context.receive(method_type, &implementation)
            )

            update_arguments(Stub.new(message_expectation:, inputs_guard:))
          end

          # Returns the stubbed method shared by all configs.
          #
          # @return [Symbol] :call or :call!
          def method_type
            @configs.first.method_type
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

          # Applies return, raise, or pass-through behavior to a stub.
          #
          # @param stub [Stub] The stub to configure
          # @param config [ServiceMockConfig] Configuration with result/exception
          # @return [void]
          def apply_return_behavior(stub, config)
            message_expectation = stub.message_expectation

            if config.pass_through?
              message_expectation.and_wrap_original(&build_pass_through(stub.inputs_guard, config))
            elsif config.failure? && config.bang_method?
              message_expectation.and_raise(config.exception)
            else
              message_expectation.and_return(config.build_result)
            end
          end

          # Builds the and_wrap_original block for a pass-through config.
          #
          # Verifies the received inputs, then delegates to the original method
          # or to the wrap block.
          #
          # @param inputs_guard [ServiceInputsGuard] Guard of the stub
          # @param config [ServiceMockConfig] Pass-through configuration
          # @return [Proc] Block for RSpec's and_wrap_original
          def build_pass_through(inputs_guard, config)
            delegate = config.wrap_original? ? WrapBlockAdapter.adapt(config.wrap_block) : CALL_ORIGINAL

            pass_through = lambda do |original, *arguments, &block|
              inputs_guard.verify!(arguments)
              delegate.call(original, *arguments, &block)
            end

            pass_through.ruby2_keywords
          end

          # Validates all configurations before executing.
          #
          # @return [void]
          # @raise [ArgumentError] If any config is invalid
          def validate_configs!
            @configs.each { |config| ExceptionValidator.validate!(config) }
          end
        end
      end
    end
  end
end
