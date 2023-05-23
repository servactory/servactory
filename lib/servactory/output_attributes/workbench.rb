# frozen_string_literal: true

module Servactory
  module OutputAttributes
    class Workbench
      def self.work_with(...)
        new(...)
      end

      def initialize(collection_of_output_attributes)
        @collection_of_output_attributes = collection_of_output_attributes
      end

      def assign(context:)
        @context = context
      end

      def find_conflicts_in!(collection_of_internal_attributes:)
        Tools::Conflicts.check!(context, collection_of_output_attributes, collection_of_internal_attributes)
      end

      def prepare
        Tools::Prepare.prepare(context, collection_of_output_attributes)
      end

      private

      attr_reader :context, :collection_of_output_attributes
    end
  end
end
