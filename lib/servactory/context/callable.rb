# frozen_string_literal: true

module Servactory
  module Context
    module Callable
      def call!(arguments = {}) # rubocop:disable Metrics/AbcSize
        context = send(:new)

        _call!(context, **arguments)

        config.result_class.success_for(context: context)
      rescue config.success_class => e
        config.result_class.success_for(context: e.context)
      rescue config.input_exception_class, config.internal_exception_class, config.output_exception_class => e
        if config.validation_mode_bang_without_throwing_exception_for_attributes?
          return config.result_class.failure_for(context: context, exception: e)
        end

        raise e
      end

      def call(arguments = {}) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        context = send(:new)

        _call!(context, **arguments)

        config.result_class.success_for(context: context)
      rescue config.success_class => e
        config.result_class.success_for(context: e.context)
      rescue config.input_exception_class, config.internal_exception_class, config.output_exception_class => e
        if config.validation_mode_bang_without_throwing_exception_for_attributes?
          return config.result_class.failure_for(context: context, exception: e)
        end

        raise e
      rescue config.failure_class => e
        config.result_class.failure_for(context: context, exception: e)
      end

      private

      def _call!(context, **arguments)
        context.send(
          :_call!,
          incoming_arguments: arguments.symbolize_keys,
          collection_of_inputs: collection_of_inputs,
          collection_of_internals: collection_of_internals,
          collection_of_outputs: collection_of_outputs,
          collection_of_stages: collection_of_stages
        )
      end
    end
  end
end
