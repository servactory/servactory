# frozen_string_literal: true

module Servactory
  module Context
    module Callable
      def call!(arguments = {})
        context = send(:new)

        context.send(
          :_call!,
          incoming_arguments: arguments,
          collection_of_inputs: collection_of_inputs,
          collection_of_internals: collection_of_internals,
          collection_of_outputs: collection_of_outputs,
          collection_of_stages: collection_of_stages
        )

        Servactory::Result.success_for(context: context)
      end

      def call(arguments = {})
        call!(arguments)
      rescue Servactory.configuration.failure_class => e
        Servactory::Result.failure_for(exception: e)
      end
    end
  end
end
