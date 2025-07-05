# frozen_string_literal: true

module Servactory
  module Actions
    class Collection
      extend Forwardable
      def_delegators :@collection, :<<, :each, :map, :sort_by

      def initialize(collection = Set.new)
        @collection = collection
      end

      def sorted_by_position
        Collection.new(sort_by(&:position))
      end
    end
  end
end
