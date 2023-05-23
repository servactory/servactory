# frozen_string_literal: true

module Servactory
  module InputAttributes
    class Workbench
      def self.work_with(...)
        new(...)
      end

      def initialize(collection_of_input_attributes)
        @collection_of_input_attributes = collection_of_input_attributes
      end

      def assign(context:, attributes:)
        @context = context
        @incoming_attributes = attributes
      end

      def find_unnecessary!
        Tools::FindUnnecessary.check!(context, @incoming_attributes, collection_of_input_attributes)
      end

      def check_rules!
        Tools::Rules.check!(context, collection_of_input_attributes)
      end

      def prepare
        Tools::Prepare.prepare(context, @incoming_attributes, collection_of_input_attributes)
      end

      def check!
        Tools::Check.check!(context, @incoming_attributes, collection_of_input_attributes)
      end

      private

      attr_reader :context,
                  :collection_of_input_attributes
    end
  end
end
