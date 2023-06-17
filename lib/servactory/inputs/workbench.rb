# frozen_string_literal: true

module Servactory
  module Inputs
    class Workbench
      attr_reader :collection,
                  :incoming_arguments

      def self.work_with(...)
        new(...)
      end

      def initialize(collection)
        @collection = collection
      end

      def assign(context:, arguments:)
        @context = context
        @incoming_arguments = arguments
      end

      def find_unnecessary!
        Tools::FindUnnecessary.validate!(context, @incoming_arguments, collection)
      end

      def check_rules!
        Tools::Rules.validate!(context, collection)
      end

      def validate!
        Tools::Validation.validate!(context, @incoming_arguments, collection)
      end

      private

      attr_reader :context
    end
  end
end
