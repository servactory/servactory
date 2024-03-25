# frozen_string_literal: true

module Servactory
  module Context
    module Callable
      def call!(arguments = {})
        prepare_result_class

        context = send(:new)

        _call!(context, **arguments)

        self::Result.success_for(context: context)
      rescue config.success_class => e
        self::Result.success_for(context: e.context)
      end

      def call(arguments = {})
        prepare_result_class

        context = send(:new)

        _call!(context, **arguments)

        self::Result.success_for(context: context)
      rescue config.success_class => e
        self::Result.success_for(context: e.context)
      rescue config.failure_class => e
        self::Result.failure_for(exception: e)
      end

      private

      def prepare_result_class
        return if Object.const_defined?("#{name}::Result")

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          Result = Class.new(Servactory::Result)
        RUBY
      end

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
