# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Helpers
        class MockExecutor
          def initialize(service_class:, configs:, rspec_context:)
            @service_class = service_class
            @configs = configs
            @rspec_context = rspec_context
          end

          def execute
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
            @configs.none? { |cfg| cfg.failure? && cfg.bang_method? }
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
              exception = config.exception || build_default_exception
              ->(*_args) { raise exception }
            else
              result = config.build_result
              ->(*_args) { result }
            end
          end

          def apply_return_behavior(message_expectation, config)
            if config.failure? && config.bang_method?
              exception = config.exception || build_default_exception
              message_expectation.and_raise(exception)
            else
              message_expectation.and_return(config.build_result)
            end
          end

          def build_default_exception
            Servactory::Exceptions::Failure.new(
              type: :base,
              message: "Service failure (mocked)"
            )
          end
        end
      end
    end
  end
end
