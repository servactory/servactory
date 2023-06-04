# frozen_string_literal: true

module Servactory
  module Methods
    class MethodCollection
      # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
      extend Forwardable
      def_delegators :@collection, :<<, :each, :merge, :sort_by, :group_by, :size, :empty?

      def initialize(collection = Set.new)
        @collection = collection
      end

      def sorted_by_position
        MethodCollection.new(sort_by(&:position))
      end

      def grouped_by_wrapper
        MethodCollection.new(group_by(&:wrapper))
      end
    end
  end
end
