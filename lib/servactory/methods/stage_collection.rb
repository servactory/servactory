# frozen_string_literal: true

module Servactory
  module Methods
    class StageCollection
      # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
      extend Forwardable
      def_delegators :@collection, :<<, :each, :merge, :sort_by, :size, :empty?

      def initialize(collection = Set.new)
        @collection = collection
      end

      def sorted_by_position
        StageCollection.new(sort_by(&:position))
      end
    end
  end
end
