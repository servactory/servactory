# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        class MockExecutor
          include Concerns::ErrorMessages

          def initialize(service_class:, configs:, rspec_context:)
            @service_class = service_class
            @configs = configs
            @rspec_context = rspec_context
          end

          def execute
            validate_configs!

            if sequential?
              execute_sequential
            else
              execute_single
            end
          end

          private

          def sequential?
            @configs.size > 1
          end

          def execute_single
            config = @configs.first
            method_name = config.method_type
            arg_matcher = config.build_argument_matcher(@rspec_context)

            message_expectation = @rspec_context.allow(@service_class).to(
              @rspec_context.receive(method_name).with(arg_matcher)
            )

            apply_return_behavior(message_expectation, config)
          end

          def execute_sequential
            method_name = @configs.first.method_type
            arg_matcher = @configs.first.build_argument_matcher(@rspec_context)

            if all_returns?
              execute_sequential_returns(method_name, arg_matcher)
            else
              execute_sequential_invoke(method_name, arg_matcher)
            end
          end

          def all_returns?
            @configs.none? { |config| config.failure? && config.bang_method? }
          end

          def execute_sequential_returns(method_name, arg_matcher)
            returns = @configs.map(&:build_result)

            @rspec_context.allow(@service_class).to(
              @rspec_context.receive(method_name)
                .with(arg_matcher)
                .and_return(*returns)
            )
          end

          def execute_sequential_invoke(method_name, arg_matcher)
            callables = @configs.map { |config| build_callable(config) }

            @rspec_context.allow(@service_class).to(
              @rspec_context.receive(method_name)
                .with(arg_matcher)
                .and_invoke(*callables)
            )
          end

          def build_callable(config)
            if config.failure? && config.bang_method?
              ->(*_args) { raise config.exception }
            else
              result = config.build_result
              ->(*_args) { result }
            end
          end

          def apply_return_behavior(message_expectation, config)
            if config.failure? && config.bang_method?
              message_expectation.and_raise(config.exception)
            else
              message_expectation.and_return(config.build_result)
            end
          end

          def validate_configs!
            @configs.each { |config| validate_config!(config) }
          end

          def validate_config!(config)
            validate_failure_has_exception!(config)
            validate_exception_type!(config)
          end

          def validate_failure_has_exception!(config)
            return unless config.failure? && config.exception.nil?

            raise ArgumentError, missing_exception_for_failure_message(config.service_class)
          end

          def validate_exception_type!(config)
            return if config.exception.nil?
            return if valid_exception_type?(config)

            raise ArgumentError, invalid_exception_type_message(
              service_class: config.service_class,
              expected_class: failure_class_for(config),
              actual_class: config.exception.class
            )
          end

          def valid_exception_type?(config)
            config.exception.is_a?(failure_class_for(config))
          end

          def failure_class_for(config)
            config.service_class.config.failure_class
          end
        end
      end
    end
  end
end
