# frozen_string_literal: true

module Servactory
  module Internals
    class Collection
      # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
      extend Forwardable
      def_delegators :@collection, :<<, :each, :map, :merge, :find

      def initialize(*)
        @collection = Set.new
      end

      def names
        map(&:name)
      end

      def find_by(name:)
        find { |internal| internal.name == name }
      end
    end
  end
end
