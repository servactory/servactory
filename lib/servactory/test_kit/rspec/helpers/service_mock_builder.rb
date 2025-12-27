# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        class ServiceMockBuilder
          include Concerns::ServiceClassValidation
          include Concerns::ErrorMessages

          attr_reader :service_class, :config

          def initialize(service_class, method_type:, rspec_context:)
            validate_service_class!(service_class)

            @service_class = service_class
            @rspec_context = rspec_context
            @config = ServiceMockConfig.new(service_class:)
            @config.method_type = method_type
            @sequential_configs = []
            @executed = false
          end

          # Result type methods
          def as_success
            @config.result_type = :success
            execute_mock
            self
          end

          def as_failure
            @config.result_type = :failure
            execute_mock
            self
          end

          # Output configuration
          def with_outputs(outputs_hash)
            validate_outputs_if_needed!(outputs_hash)
            @config.outputs = @config.outputs.merge(outputs_hash)
            re_execute_mock
            self
          end

          def with_output(name, value)
            with_outputs(name => value)
          end

          # Exception configuration (for failures)
          def with_exception(exception)
            @config.exception = exception
            re_execute_mock
            self
          end

          # Input argument matching
          def when_called_with(args_hash_or_matcher)
            @config.argument_matcher = args_hash_or_matcher
            re_execute_mock
            self
          end

          # Output validation toggle
          def validate_outputs!
            @config.validate_outputs = true
            self
          end

          def skip_output_validation
            @config.validate_outputs = false
            self
          end

          # Sequential returns
          def then_as_success
            finalize_current_to_sequence
            @config = ServiceMockConfig.new(service_class:)
            @config.result_type = :success
            @config.method_type = @sequential_configs.last&.method_type || :call
            execute_sequential_mock
            self
          end

          def then_as_failure
            finalize_current_to_sequence
            @config = ServiceMockConfig.new(service_class:)
            @config.result_type = :failure
            @config.method_type = @sequential_configs.last&.method_type || :call
            execute_sequential_mock
            self
          end

          private

          def finalize_current_to_sequence
            @sequential_configs << @config.dup
          end

          def execute_mock
            return if @executed

            @executed = true
            MockExecutor.new(
              service_class:,
              configs: [@config],
              rspec_context: @rspec_context
            ).execute
          end

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

          def execute_sequential_mock
            all_configs = @sequential_configs + [@config]

            MockExecutor.new(
              service_class:,
              configs: all_configs,
              rspec_context: @rspec_context
            ).execute
          end

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
