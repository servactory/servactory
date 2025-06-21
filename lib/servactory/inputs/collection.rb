# frozen_string_literal: true

module Servactory
  module Inputs
    class Collection
      extend Forwardable
      def_delegators :@collection, :<<, :filter, :each, :map, :flat_map, :to_h, :merge, :find

      def initialize(collection = Set.new)
        @collection = Set.new(collection)
      end

      def only(*names)
        Collection.new(filter { |input| names.include?(input.internal_name) })
      end

      def except(*names)
        Collection.new(filter { |input| names.exclude?(input.internal_name) })
      end

      def names
        map(&:name)
      end

      def find_by(name:)
        find { |input| input.internal_name == name }
      end
    end
  end
end
