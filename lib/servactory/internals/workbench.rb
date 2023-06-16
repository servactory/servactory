# frozen_string_literal: true

module Servactory
  module Internals
    class Workbench
      def self.work_with(...)
        new(...)
      end

      def initialize(collection_of_internals)
        @collection_of_internals = collection_of_internals
      end

      def assign(context:)
        @context = context
      end

      private

      attr_reader :context,
                  :collection_of_internals
    end
  end
end
