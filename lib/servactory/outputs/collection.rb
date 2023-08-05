# frozen_string_literal: true

module Servactory
  module Outputs
    class Collection
      # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
      extend Forwardable
      def_delegators :@collection, :<<, :filter, :each, :map, :to_h, :merge, :find

      def initialize(collection = Set.new)
        @collection = collection
      end

      def only(*internal_names)
        Collection.new(filter { |internal| internal_names.include?(internal.name) })
      end

      def except(*internal_names)
        Collection.new(filter { |internal| !internal_names.include?(internal.name) })
      end

      def names
        map(&:name)
      end

      def find_by(name:)
        find { |output| output.name == name }
      end
    end
  end
end
