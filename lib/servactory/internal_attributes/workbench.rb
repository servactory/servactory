# frozen_string_literal: true

module Servactory
  module InternalAttributes
    class Workbench
      def self.work_with(...)
        new(...)
      end

      def initialize(collection_of_internal_attributes)
        @collection_of_internal_attributes = collection_of_internal_attributes
      end

      def assign(context:)
        @context = context
      end

      def prepare
        Tools::Prepare.prepare(context, collection_of_internal_attributes)
      end

      private

      attr_reader :context,
                  :collection_of_internal_attributes
    end
  end
end
