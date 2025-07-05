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

          collection.merge!(incoming_arguments)
        end

        def self.clear
          @collection = {}
        end
      end

      def call!(arguments = {})
        Arguments.merge(arguments)

        context = send(:new, Arguments.collection)

        Arguments.clear

        _call!(context)

        config.result_class.success_for(context:)
      rescue config.success_class => e
        config.result_class.success_for(context: e.context)
      end

      def call(arguments = {}) # rubocop:disable Metrics/AbcSize
        Arguments.merge(arguments)

        context = send(:new, Arguments.collection)

        Arguments.clear

        _call!(context)

        config.result_class.success_for(context:)
      rescue config.success_class => e
        config.result_class.success_for(context: e.context)
      rescue config.failure_class => e
        config.result_class.failure_for(context:, exception: e)
      end

      def method_missing(name, *args)
        return super unless (input = collection_of_inputs.find_by(name:)).present?

        value = args.first
        value = true if input.types.include?(TrueClass) && value.nil?

        Arguments.add(name, value)

        self
      end

      def respond_to_missing?(name, *)
        collection_of_inputs.names.include?(name) || super
      end

      private

      def _call!(context)
        context.send(
          :_call!,
          collection_of_inputs:,
          collection_of_internals:,
          collection_of_outputs:,
          collection_of_stages:
        )
      end
    end
  end
end
