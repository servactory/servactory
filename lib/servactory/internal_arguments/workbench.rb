# frozen_string_literal: true

module Servactory
  module InternalArguments
    class Workbench
      def self.work_with(...)
        new(...)
      end

      def initialize(collection_of_internal_arguments)
        @collection_of_internal_arguments = collection_of_internal_arguments
      end

      def assign(context:)
        @context = context
      end

      def prepare
        Tools::Prepare.prepare(context, collection_of_internal_arguments)
      end

      private

      attr_reader :context, :collection_of_internal_arguments
    end
  end
end
