# frozen_string_literal: true

module Servactory
  module Methods
    class Workbench
      def self.work_with(...)
        new(...)
      end

      def initialize(collection_of_methods)
        @collection_of_methods = collection_of_methods
      end

      def assign(context:)
        @context = context
      end

      def run!
        return try_to_use_call if collection_of_methods.empty?

        collection_of_methods.each do |make_method|
          next if unnecessary_for?(make_method)

          context.send(make_method.name)
        end
      end

      private

      attr_reader :context,
                  :collection_of_methods

      def try_to_use_call
        context.try(:send, :call)
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
