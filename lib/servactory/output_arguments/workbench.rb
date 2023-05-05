# frozen_string_literal: true

module Servactory
  module OutputArguments
    class Workbench
      def self.work_with(...)
        new(...)
      end

      def initialize(collection_of_output_arguments)
        @collection_of_output_arguments = collection_of_output_arguments
      end

      def assign(context:)
        @context = context
      end

      def find_conflicts_in!(collection_of_internal_arguments:)
        Tools::Conflicts.check!(context, collection_of_output_arguments, collection_of_internal_arguments)
      end

      def prepare
        Tools::Prepare.prepare(context, collection_of_output_arguments)
      end

      private

      attr_reader :context, :collection_of_output_arguments
    end
  end
end
