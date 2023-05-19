# frozen_string_literal: true

module Servactory
  module OutputArguments
    class Collection
      # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
      extend Forwardable
      def_delegators :@collection, :<<, :each, :map, :merge

      def initialize(*)
        @collection = Set.new
      end

      def names
        map(&:name)
      end
    end
  end
end
