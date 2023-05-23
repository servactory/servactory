# frozen_string_literal: true

module Servactory
  module Errors
    class Collection
      # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
      extend Forwardable
      def_delegators :@collection, :<<, :to_a, :filter, :reject, :empty?, :first

      def initialize(collection = Set.new)
        @collection = collection
      end

      def not_blank
        Collection.new(reject(&:blank?))
      end

      def for_fails
        filtered = filter { |error| error.is_a?(Failure) }

        Collection.new(filtered)
      end
    end
  end
end
