# frozen_string_literal: true

module Servactory
  module Context
    module Callable
      def call!(arguments = {})
        context = send(:new)

        _call!(context, **arguments)

        Servactory::Result.success_for(context: context)
      rescue config.success_class => e
        Servactory::Result.success_for(context: e.context)
      end

      def call(arguments = {})
        context = send(:new)

        _call!(context, **arguments)

        Servactory::Result.success_for(context: context)
      rescue config.success_class => e
        Servactory::Result.success_for(context: e.context)
      rescue config.failure_class => e
        Servactory::Result.failure_for(context: context, exception: e)
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
