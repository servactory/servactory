# frozen_string_literal: true

module Servactory
  module Context
    module Callable
      def call!(arguments = {}) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        unless Object.const_defined?("#{name}::Result")
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            Result = Class.new(Servactory::Result)
          RUBY
        end

        context = send(:new)

        context.send(
          :_call!,
          incoming_arguments: arguments.symbolize_keys,
          collection_of_inputs: collection_of_inputs,
          collection_of_internals: collection_of_internals,
          collection_of_outputs: collection_of_outputs,
          collection_of_stages: collection_of_stages
        )

        context.class::Result.success_for(context: context)
      rescue config.success_class => e
        context.class::Result.success_for(context: e.context)
      end

      def call(arguments = {}) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        unless Object.const_defined?("#{name}::Result")
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            Result = Class.new(Servactory::Result)
          RUBY
        end

        context = send(:new)

        context.send(
          :_call!,
          incoming_arguments: arguments.symbolize_keys,
          collection_of_inputs: collection_of_inputs,
          collection_of_internals: collection_of_internals,
          collection_of_outputs: collection_of_outputs,
          collection_of_stages: collection_of_stages
        )

        context.class::Result.success_for(context: context)
      rescue config.success_class => e
        context.class::Result.success_for(context: e.context)
      rescue config.failure_class => e
        context.class::Result.failure_for(exception: e)
      end
    end
  end
end
