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
        collection_of_methods.each do |make_method|
          next if unnecessary_for?(make_method)

          context.send(make_method.name)
        end
      end

      private

      attr_reader :context,
                  :collection_of_methods

      def unnecessary_for?(make_method)
        condition = make_method.condition

        return false if condition.nil?
        return !Servactory::Utils.boolean?(condition) unless condition.is_a?(Proc)

        !condition.call(context: context)
      end
    end
  end
end
