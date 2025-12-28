# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        # Fluent builder for configuring Servactory service mocks in RSpec tests.
        #
        # ## Purpose
        #
        # ServiceMockBuilder provides a fluent API for stubbing Servactory service calls
        # in tests. It handles both success and failure scenarios, output configuration,
        # input argument matching, and sequential call responses.
        #
        # ## Usage
        #
        # Basic success mock:
        #
        # ```ruby
        # allow_service(MyService)
        #   .as_success
        #   .outputs(result: "value")
        # ```
        #
        # Failure mock with exception:
        #
        # ```ruby
        # allow_service(MyService)
        #   .as_failure
        #   .with_exception(MyService::Failure.new(message: "Error"))
        # ```
        #
        # Sequential returns (first call succeeds, second fails):
        #
        # ```ruby
        # allow_service(MyService)
        #   .as_success.outputs(count: 1)
        #   .then_as_success.outputs(count: 2)
        #   .then_as_failure.with_exception(error)
        # ```
        #
        # With input matching:
        #
        # ```ruby
        # allow_service(MyService)
        #   .as_success
        #   .inputs(user_id: 123)
        #   .outputs(user: user)
        # ```
        #
        # ## Features
        #
        # - **Fluent API** - chainable methods for readable test setup
        # - **Success/Failure** - configure expected result type
        # - **Output Configuration** - specify mock output values
        # - **Exception Handling** - attach exceptions for failure mocks
        # - **Input Matching** - match specific service inputs
        # - **Sequential Responses** - different results for consecutive calls
        # - **Output Validation** - optionally validate outputs against service definition
        #
        # ## Architecture
        #
        # Works with:
        # - ServiceMockConfig - holds mock configuration state
        # - MockExecutor - executes the actual RSpec stubbing
        # - OutputValidator - validates outputs match service definition
        class ServiceMockBuilder # rubocop:disable Metrics/ClassLength
          include Concerns::ServiceClassValidation
          include Concerns::ErrorMessages

          # @return [Class] The Servactory service class being mocked
          attr_reader :service_class

          # @return [ServiceMockConfig] Current mock configuration
          attr_reader :config

          # Creates a new service mock builder.
          #
          # @param service_class [Class] The Servactory service class to mock
          # @param method_type [Symbol] The method to stub (:call or :call!)
          # @param rspec_context [Object] The RSpec example context for stubbing
          def initialize(service_class, method_type:, rspec_context:)
            validate_service_class!(service_class)

            @service_class = service_class
            @rspec_context = rspec_context
            @config = ServiceMockConfig.new(service_class:)
            @config.method_type = method_type
            @sequential_configs = []
            @executed = false
          end

          # Configures the mock to return a successful result.
          #
          # Executes the mock immediately after setting result type.
          #
          # @return [ServiceMockBuilder] self for method chaining
          def as_success
            @config.result_type = :success
            execute_mock
            self
          end

          # Configures the mock to return a failure result.
          #
          # Does not execute mock immediately - waits for with_exception to be called,
          # as failure mocks require an exception to be specified.
          #
          # @return [ServiceMockBuilder] self for method chaining
          def as_failure
            @config.result_type = :failure
            # Don't execute mock yet - wait for with_exception.
            # Validation requires exception for failures.
            self
          end

          # Sets output values for the mock result.
          #
          # @param outputs_hash [Hash{Symbol => Object}] Output name-value pairs
          # @return [ServiceMockBuilder] self for method chaining
          def outputs(outputs_hash)
            validate_outputs_if_needed!(outputs_hash)
            @config.outputs = @config.outputs.merge(outputs_hash)
            re_execute_mock
            self
          end

          # Sets a single output value for the mock result.
          #
          # @param name [Symbol] Output name
          # @param value [Object] Output value
          # @return [ServiceMockBuilder] self for method chaining
          def output(name, value)
            outputs(name => value)
          end

          # Attaches an exception to a failure mock.
          #
          # For bang methods (call!), the exception will be raised.
          # For non-bang methods (call), the exception will be wrapped in the result.
          #
          # @param exception [Exception] The failure exception instance
          # @return [ServiceMockBuilder] self for method chaining
          def with_exception(exception)
            @config.exception = exception

            if @sequential_configs.any?
              execute_sequential_mock
            elsif @executed
              re_execute_mock
            else
              execute_mock
            end

            self
          end

          # Configures input matching for the mock.
          #
          # @param inputs_hash_or_matcher [Hash, Object] Service inputs to match or RSpec matcher
          # @return [ServiceMockBuilder] self for method chaining
          def inputs(inputs_hash_or_matcher)
            @config.argument_matcher = inputs_hash_or_matcher
            re_execute_mock
            self
          end

          # Enables output validation against service definition.
          #
          # When enabled, outputs will validate that output names
          # match the service's declared outputs.
          #
          # @return [ServiceMockBuilder] self for method chaining
          def validate_outputs!
            @config.validate_outputs = true
            self
          end

          # Disables output validation.
          #
          # @return [ServiceMockBuilder] self for method chaining
          def skip_output_validation
            @config.validate_outputs = false
            self
          end

          # Adds a successful result for sequential call handling.
          #
          # Use for testing code that calls the same service multiple times.
          #
          # @return [ServiceMockBuilder] self for method chaining
          def then_as_success
            finalize_current_to_sequence
            @config = ServiceMockConfig.new(service_class:)
            @config.result_type = :success
            @config.method_type = @sequential_configs.last&.method_type || :call
            execute_sequential_mock
            self
          end

          # Adds a failure result for sequential call handling.
          #
          # Use for testing code that calls the same service multiple times.
          # Requires with_exception to be called afterward.
          #
          # @return [ServiceMockBuilder] self for method chaining
          def then_as_failure
            finalize_current_to_sequence
            @config = ServiceMockConfig.new(service_class:)
            @config.result_type = :failure
            @config.method_type = @sequential_configs.last&.method_type || :call
            # Don't execute mock yet - wait for with_exception.
            self
          end

          private

          # Saves current config to sequential list.
          #
          # @return [void]
          def finalize_current_to_sequence
            @sequential_configs << @config.dup
          end

          # Executes the mock for the first time.
          #
          # @return [void]
          def execute_mock
            return if @executed

            @executed = true
            MockExecutor.new(
              service_class:,
              configs: [@config],
              rspec_context: @rspec_context
            ).execute
          end

          # Re-executes the mock after configuration changes.
          #
          # @return [void]
          def re_execute_mock
            return unless @executed

            if @sequential_configs.any?
              execute_sequential_mock
            else
              MockExecutor.new(
                service_class:,
                configs: [@config],
                rspec_context: @rspec_context
              ).execute
            end
          end

          # Executes the mock with all sequential configurations.
          #
          # @return [void]
          def execute_sequential_mock
            all_configs = @sequential_configs + [@config]

            MockExecutor.new(
              service_class:,
              configs: all_configs,
              rspec_context: @rspec_context
            ).execute
          end

          # Validates outputs against service definition if validation is enabled.
          #
          # @param outputs_hash [Hash] Outputs to validate
          # @return [void]
          # @raise [OutputValidator::InvalidOutputError] If outputs don't match service definition
          def validate_outputs_if_needed!(outputs_hash)
            return unless @config.validate_outputs?

            OutputValidator.validate!(
              service_class:,
              outputs: outputs_hash
            )
          end
        end
      end
    end
  end
end
