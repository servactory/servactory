# frozen_string_literal: true

module Servactory
  module Internals
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

      private

      attr_reader :context
    end
  end
end
