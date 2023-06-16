# frozen_string_literal: true

module Servactory
  module Outputs
    class Workbench
      attr_reader :collection

      def self.work_with(...)
        new(...)
      end

      def initialize(collection)
        @collection = collection
      end

      def assign(context:)
        @context = context
      end

      def find_conflicts_in!(collection_of_internals:)
        Tools::Conflicts.validate!(context, collection, collection_of_internals)
      end

      private

      attr_reader :context
    end
  end
end
