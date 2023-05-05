# frozen_string_literal: true

module Servactory
  module Stage
    class Handyman
      def self.work_in(...)
        new(...)
      end

      def initialize(factory)
        @factory = factory
      end

      def assign(context:)
        @context = context
      end

      def methods
        factory.methods
      end

      def run_methods!
        methods.each do |method|
          next if method.condition && !method.condition.call(context)

          context.send(method.name)
        end
      end

      private

      attr_reader :factory, :context
    end
  end
end
