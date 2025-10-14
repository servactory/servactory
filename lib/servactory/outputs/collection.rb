# frozen_string_literal: true

module Servactory
  module Outputs
    class Collection
      extend Forwardable

      def_delegators :@collection, :<<, :filter, :each, :map, :to_h, :merge, :find

      def initialize(collection = Set.new)
        @collection = collection
      end

      def only(*names)
        Collection.new(filter { |internal| names.include?(internal.name) })
      end

      def except(*names)
        Collection.new(filter { |internal| names.exclude?(internal.name) })
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
