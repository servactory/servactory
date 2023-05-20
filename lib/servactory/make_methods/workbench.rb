# frozen_string_literal: true

module Servactory
  module MakeMethods
    class Workbench
      def self.work_with(...)
        new(...)
      end

      def initialize(collection_of_make_methods)
        @collection_of_make_methods = collection_of_make_methods
      end

      
      def assign(context:)
        @context = context
      end

      def run!
        collection_of_make_methods.each do |make_method|
          next if unnecessary_for?(make_method)

          context.send(make_method.name)
        end
      end

      private

      attr_reader :context, :collection_of_make_methods

      def unnecessary_for?(make_method)
        condition = make_method.condition

        return false if condition.blank?
        return !Servactory::Utils.boolean?(condition) unless condition.is_a?(Proc)

        !condition.call(context)
      end
    end
  end
end
