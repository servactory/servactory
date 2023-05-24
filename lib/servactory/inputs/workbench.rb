# frozen_string_literal: true

module Servactory
  module Inputs
    class Workbench
      def self.work_with(...)
        new(...)
      end

      def initialize(collection_of_inputs)
        @collection_of_inputs = collection_of_inputs
      end

      def assign(context:, attributes:)
        @context = context
        @incoming_attributes = attributes
      end

      def find_unnecessary!
        Tools::FindUnnecessary.check!(context, @incoming_attributes, collection_of_inputs)
      end

      def check_rules!
        Tools::Rules.check!(context, collection_of_inputs)
      end

      def prepare
        Tools::Prepare.prepare(context, @incoming_attributes, collection_of_inputs)
      end

      def check!
        Tools::Check.check!(context, @incoming_attributes, collection_of_inputs)
      end

      private

      attr_reader :context,
                  :collection_of_inputs
    end
  end
end
