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
        #   .succeeds(result: "value")
        # ```
        #
        # Failure mock:
        #
        # ```ruby
        # allow_service(MyService)
        #   .fails(type: :base, message: "Error")
        # ```
        #
        # Failure mock with custom exception class:
        #
        # ```ruby
        # allow_service(MyService)
        #   .fails(CustomException, type: :base, message: "Error")
        # ```
        #
        # Sequential returns (first call succeeds, second fails):
        #
        # ```ruby
        # allow_service(MyService)
        #   .succeeds(count: 1)
        #   .then_succeeds(count: 2)
        #   .then_fails(type: :base, message: "Error")
        # ```
        #
        # With input matching:
        #
        # ```ruby
        # allow_service(MyService)
        #   .with(user_id: 123)
        #   .succeeds(user: user)
        #
        # # Or order doesn't matter:
        # allow_service(MyService)
        #   .succeeds(user: user)
        #   .with(user_id: 123)
        # ```
        #
        # ## Features
        #
        # - **Fluent API** - chainable methods for readable test setup
        # - **Success/Failure** - configure expected result type in one method
        # - **Exception Handling** - auto-creates exceptions with type, message, meta
        # - **Input Matching** - match specific service inputs with `.with()`
        # - **Sequential Responses** - different results for consecutive calls
        # - **Automatic Validation** - validates inputs and outputs against service definition
        #
        # ## Architecture
        #
        # Works with:
        # - ServiceMockConfig - holds mock configuration state
        # - MockExecutor - executes the actual RSpec stubbing
        # - OutputValidator - validates outputs match service definition
        # - InputValidator - validates inputs match service definition
        class ServiceMockBuilder # rubocop:disable Metrics/ClassLength
          include Concerns::ServiceClassValidation
          include Concerns::ErrorMessages

          RESULT_TYPE_TO_METHOD = {
            success: :succeeds,
            failure: :fails,
            call_original: :and_call_original,
            wrap_original: :and_wrap_original
          }.freeze

          private_constant :RESULT_TYPE_TO_METHOD

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

          # ============================================================
          # Primary Fluent API
          # ============================================================

          # Configures the mock to return a successful result with outputs.
          #
          # Outputs are automatically validated against service definition.
          #
          # @param outputs_hash [Hash{Symbol => Object}] Output name-value pairs
          # @return [ServiceMockBuilder] self for method chaining
          #
          # @example Basic success
          #   allow_service(PaymentService).succeeds(status: :completed)
          #
          # @example With input matching
          #   allow_service(PaymentService)
          #     .succeeds(transaction_id: "txn_123")
          #     .with(amount: 100)
          #
          # @raise [ArgumentError] if called after then_succeeds/then_fails
          # @raise [OutputValidator::ValidationError] if outputs don't match service definition
          def succeeds(outputs_hash = {})
            validate_not_in_sequential_mode!(:succeeds)
            validate_result_type_not_switched!(:succeeds)

            validate_outputs!(outputs_hash)
            @config.result_type = :success
            @config.outputs = outputs_hash
            execute_or_re_execute_mock
            self
          end

          # Configures the mock to return a failure result with exception.
          #
          # @param exception_class [Class, nil] Exception class (default: service config.failure_class)
          # @param type [Symbol] Error type (default: :base)
          # @param message [String] Error message (required)
          # @param meta [Object, nil] Optional metadata for the exception
          # @return [ServiceMockBuilder] self for method chaining
          #
          # @example Minimal failure
          #   allow_service(PaymentService).fails(message: "Card declined")
          #
          # @example With type
          #   allow_service(PaymentService)
          #     .fails(type: :payment_declined, message: "Insufficient funds")
          #
          # @example With custom exception class
          #   allow_service(PaymentService)
          #     .fails(CustomException, type: :error, message: "Error")
          #
          # @raise [ArgumentError] if called after then_succeeds/then_fails
          def fails(exception_class = nil, type: :base, message:, meta: nil) # rubocop:disable Style/KeywordParametersOrder
            validate_not_in_sequential_mode!(:fails)
            validate_result_type_not_switched!(:fails)

            @config.result_type = :failure
            @config.exception = build_exception(exception_class, type:, message:, meta:)
            execute_or_re_execute_mock
            self
          end

          # Configures input matching for the mock.
          #
          # Can be called at any position in the chain (before/after succeeds/fails,
          # or after then_* methods). Applies to the entire mock chain.
          #
          # Inputs are automatically validated against service definition.
          #
          # @param inputs_hash_or_matcher [Hash, Object] Service inputs to match or RSpec matcher
          # @return [ServiceMockBuilder] self for method chaining
          #
          # @example Exact match
          #   allow_service(S).with(amount: 100).succeeds(result: :ok)
          #
          # @example With matchers
          #   allow_service(S).with(including(amount: 100)).succeeds(result: :ok)
          #
          # @example Any position in chain
          #   allow_service(S).succeeds(result: :ok).with(amount: 100)
          #
          # @raise [InputValidator::ValidationError] if inputs don't match service definition
          def with(inputs_hash_or_matcher)
            validate_inputs!(inputs_hash_or_matcher)
            @config.argument_matcher = inputs_hash_or_matcher
            re_execute_mock if @executed
            self
          end

          # ============================================================
          # RSpec Pass-Through API
          # ============================================================

          # Delegates to the original unmodified method.
          # Useful for spy pattern or selective mocking.
          #
          # @return [ServiceMockBuilder] self for method chaining
          #
          # @example Pass-through (spy)
          #   allow_service(S).and_call_original
          #
          # @example Selective mocking with input matching
          #   allow_service(S).with(id: 1).and_call_original
          def and_call_original
            validate_not_in_sequential_mode!(:and_call_original)
            validate_result_type_not_switched!(:and_call_original)

            @config.result_type = :call_original
            execute_or_re_execute_mock
            self
          end

          # Wraps the original method with custom logic.
          # Block receives the original method and call arguments.
          #
          # @yield [original, **inputs] Block wrapping the original
          # @return [ServiceMockBuilder] self for method chaining
          #
          # @example Modify result
          #   allow_service(S).and_wrap_original do |original, **inputs|
          #     result = original.call(**inputs)
          #     # custom logic
          #     result
          #   end
          def and_wrap_original(&block)
            validate_not_in_sequential_mode!(:and_wrap_original)
            validate_result_type_not_switched!(:and_wrap_original)

            @config.result_type = :wrap_original
            @config.wrap_block = block
            execute_or_re_execute_mock
            self
          end

          # ============================================================
          # Sequential Call API
          # ============================================================

          # Adds a successful result for sequential call handling.
          #
          # Use for testing code that calls the same service multiple times.
          # Outputs are automatically validated against service definition.
          #
          # @param outputs_hash [Hash{Symbol => Object}] Output name-value pairs
          # @return [ServiceMockBuilder] self for method chaining
          #
          # @example Multiple successes
          #   allow_service(RetryService)
          #     .succeeds(status: :pending)
          #     .then_succeeds(status: :completed)
          #
          # @raise [ArgumentError] if called without first calling succeeds/fails
          # @raise [OutputValidator::ValidationError] if outputs don't match service definition
          def then_succeeds(outputs_hash = {})
            validate_not_passthrough!(:then_succeeds)
            validate_result_type_defined!(:then_succeeds)

            validate_outputs!(outputs_hash)
            finalize_current_to_sequence
            @config = ServiceMockConfig.new(service_class:)
            @config.result_type = :success
            @config.outputs = outputs_hash
            @config.method_type = @sequential_configs.last&.method_type || :call
            execute_sequential_mock
            self
          end

          # Adds a failure result for sequential call handling.
          #
          # Use for testing code that calls the same service multiple times.
          #
          # @param exception_class [Class, nil] Exception class (default: service config.failure_class)
          # @param type [Symbol] Error type (default: :base)
          # @param message [String] Error message (required)
          # @param meta [Object, nil] Optional metadata for the exception
          # @return [ServiceMockBuilder] self for method chaining
          #
          # @example Success then failure
          #   allow_service(RetryService)
          #     .succeeds(status: :pending)
          #     .then_fails(type: :timeout, message: "Request timed out")
          #
          # @raise [ArgumentError] if called without first calling succeeds/fails
          def then_fails(exception_class = nil, type: :base, message:, meta: nil) # rubocop:disable Style/KeywordParametersOrder
            validate_not_passthrough!(:then_fails)
            validate_result_type_defined!(:then_fails)

            finalize_current_to_sequence
            @config = ServiceMockConfig.new(service_class:)
            @config.result_type = :failure
            @config.exception = build_exception(exception_class, type:, message:, meta:)
            @config.method_type = @sequential_configs.last&.method_type || :call
            execute_sequential_mock
            self
          end

          private

          # ============================================================
          # Validation
          # ============================================================

          # Validates that we're not in sequential mode.
          #
          # @param method_name [Symbol] The method being called
          # @raise [ArgumentError] if in sequential mode
          # @return [void]
          def validate_not_in_sequential_mode!(method_name)
            return if @sequential_configs.empty?

            raise ArgumentError,
                  "Cannot call #{method_name}() after then_succeeds/then_fails. " \
                  "Use then_succeeds() or then_fails() to add sequential responses."
          end

          # Validates that result type is defined.
          #
          # @param method_name [Symbol] The method being called
          # @raise [ArgumentError] if result type is not defined
          # @return [void]
          def validate_result_type_defined!(method_name)
            return if @config.result_type_defined?

            raise ArgumentError,
                  "Cannot call #{method_name}() without first calling succeeds() or fails()."
          end

          # Validates that result type is not being switched.
          #
          # Prevents accidental switching between different result types.
          #
          # @param new_type [Symbol] :succeeds, :fails, :and_call_original, or :and_wrap_original
          # @raise [ArgumentError] if trying to switch result type
          # @return [void]
          def validate_result_type_not_switched!(new_type)
            return unless @config.result_type_defined?

            current_type = RESULT_TYPE_TO_METHOD[@config.result_type]
            return if new_type == current_type

            raise ArgumentError,
                  "Cannot call #{new_type}() after #{current_type}() was already called. " \
                  "This replaces the result type, which is likely a mistake. " \
                  "Create a new mock if you need different behavior."
          end

          # Validates that pass-through methods are not mixed with sequential responses.
          #
          # @param method_name [Symbol] The method being called
          # @raise [ArgumentError] if current config is a pass-through type
          # @return [void]
          def validate_not_passthrough!(method_name)
            return unless @config.call_original? || @config.wrap_original?

            passthrough = @config.call_original? ? :and_call_original : :and_wrap_original

            raise ArgumentError,
                  "Cannot call #{method_name}() after #{passthrough}(). " \
                  "Pass-through methods are not compatible with sequential responses."
          end

          # Validates outputs against service definition.
          #
          # @param outputs_hash [Hash] Outputs to validate
          # @return [void]
          # @raise [OutputValidator::ValidationError] If outputs don't match service definition
          def validate_outputs!(outputs_hash)
            return if outputs_hash.empty?

            OutputValidator.validate!(
              service_class:,
              outputs: outputs_hash
            )
          end

          # Validates inputs against service definition.
          #
          # @param inputs_matcher [Hash, Object] Inputs or matcher to validate
          # @return [void]
          # @raise [InputValidator::ValidationError] If inputs don't match service definition
          def validate_inputs!(inputs_matcher)
            InputValidator.validate!(
              service_class:,
              inputs_matcher:
            )
          end

          # ============================================================
          # Exception Building
          # ============================================================

          # Builds exception instance for failure mocks.
          #
          # Uses service's configured failure_class if no exception_class provided.
          #
          # @param exception_class [Class, nil] Exception class to use
          # @param type [Symbol] Error type
          # @param message [String] Error message
          # @param meta [Object, nil] Optional metadata
          # @return [Exception] The constructed exception instance
          def build_exception(exception_class, type:, message:, meta:)
            klass = exception_class || default_failure_class
            klass.new(type:, message:, meta:)
          end

          # Gets the default failure class from service configuration.
          #
          # @return [Class] The service's configured failure class
          def default_failure_class
            service_class.config.failure_class
          end

          # ============================================================
          # Mock Execution
          # ============================================================

          # Executes or re-executes mock depending on current state.
          #
          # @return [void]
          def execute_or_re_execute_mock
            if @executed
              re_execute_mock
            else
              execute_mock
            end
          end

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
        end
      end
    end
  end
end
