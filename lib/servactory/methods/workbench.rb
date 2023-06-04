# frozen_string_literal: true

module Servactory
  module Methods
    class Workbench
      def self.work_with(...)
        new(...)
      end

      def initialize(collection_of_stages)
        @collection_of_stages = collection_of_stages
      end

      def assign(context:)
        @context = context
      end

      def run!
        return try_to_use_call if collection_of_stages.empty?

        collection_of_stages.sorted_by_position.each do |stage|
          wrapper = stage.wrapper
          rollback = stage.rollback
          methods = stage.methods.sorted_by_position

          if wrapper.is_a?(Proc)
            call_wrapper_with_methods(wrapper, rollback, methods)
          else
            call_methods(methods)
          end
        end
      end

      private

      attr_reader :context,
                  :collection_of_stages

      def try_to_use_call
        context.try(:send, :call)
      end

      def call_wrapper_with_methods(wrapper, rollback, methods)
        wrapper.call(methods: call_methods(methods))
      rescue StandardError => e
        context.send(rollback, e)
      end

      def call_methods(methods)
        methods.each do |make_method|
          next if unnecessary_for?(make_method)

          context.send(make_method.name)
        end
      end

      def unnecessary_for?(make_method)
        condition = make_method.condition
        is_condition_opposite = make_method.is_condition_opposite

        result = prepare_condition_for(condition)

        is_condition_opposite ? !result : result
      end

      def prepare_condition_for(condition)
        return false if condition.nil?
        return !Servactory::Utils.true?(condition) unless condition.is_a?(Proc)

        !condition.call(context: context)
      end
    end
  end
end
