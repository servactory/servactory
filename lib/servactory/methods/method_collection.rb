# frozen_string_literal: true

module Servactory
  module Methods
    class MethodCollection
      # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
      extend Forwardable
      def_delegators :@collection, :<<, :each, :sort_by

      def initialize(collection = Set.new)
        @collection = collection
      end

      def sorted_by_position
        MethodCollection.new(sort_by(&:position))
      end
    end
  end
end
