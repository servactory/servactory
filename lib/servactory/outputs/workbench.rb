# frozen_string_literal: true

module Servactory
  module Outputs
    class Workbench
      def self.work_with(...)
        new(...)
      end

      def initialize(collection_of_outputs)
        @collection_of_outputs = collection_of_outputs
      end

      def assign(context:)
        @context = context
      end

      def find_conflicts_in!(collection_of_internals:)
        Tools::Conflicts.validate!(context, collection_of_outputs, collection_of_internals)
      end

      def prepare
        Tools::Prepare.prepare(context, collection_of_outputs)
      end

      private

      attr_reader :context, :collection_of_outputs
    end
  end
end
