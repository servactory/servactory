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

      def assign(context:, arguments:)
        @context = context
        @incoming_arguments = arguments
      end

      def find_unnecessary!
        Tools::FindUnnecessary.validate!(context, @incoming_arguments, collection_of_inputs)
      end

      def check_rules!
        Tools::Rules.validate!(context, collection_of_inputs)
      end

      def prepare
        Tools::Prepare.prepare(context, @incoming_arguments, collection_of_inputs)
      end

      def validate!
        Tools::Validation.validate!(context, @incoming_arguments, collection_of_inputs)
      end

      private

      attr_reader :context,
                  :collection_of_inputs
    end
  end
end
