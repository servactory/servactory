# frozen_string_literal: true

module Servactory
  module Context
    module Callable
      module Arguments
        def self.collection
          @collection ||= {}
        end

        def self.add(name, value)
          collection[name] = value
        end

        def self.merge(incoming_arguments)
          incoming_arguments = Servactory::Utils.adapt(incoming_arguments)

          collection.merge(incoming_arguments)
        end

        def self.clear
          @collection = {}
        end
      end

      def call!(arguments = {})
        context = send(:new, Arguments.merge(arguments))

        _call!(context, Arguments.merge(arguments))

        Arguments.clear

        config.result_class.success_for(context:)
      rescue config.success_class => e
        config.result_class.success_for(context: e.context)
      end

      def call(arguments = {})
        context = send(:new, Arguments.merge(arguments))

        _call!(context, Arguments.merge(arguments))

        Arguments.clear

        config.result_class.success_for(context:)
      rescue config.success_class => e
        config.result_class.success_for(context: e.context)
      rescue config.failure_class => e
        config.result_class.failure_for(context:, exception: e)
      end

      def method_missing(name, *args)
        return super unless collection_of_inputs.names.include?(name)

        Arguments.add(name, args.first)

        self
      end

      def respond_to_missing?(name, *)
        collection_of_inputs.names.include?(name) || super
      end

      private

      def _call!(context, incoming_arguments)
        context.send(
          :_call!,
          incoming_arguments:,
          collection_of_inputs:,
          collection_of_internals:,
          collection_of_outputs:,
          collection_of_stages:
        )
      end
    end
  end
end
