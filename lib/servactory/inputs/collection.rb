# frozen_string_literal: true

module Servactory
  module Inputs
    class Collection
      extend Forwardable
      def_delegators :@collection, :<<, :filter, :each, :map, :to_h, :merge, :find

      def initialize(collection = Set.new)
        @collection = collection
      end

      def only(*input_names)
        Collection.new(filter { |input| input_names.include?(input.internal_name) })
      end

      def except(*input_names)
        Collection.new(filter { |input| !input_names.include?(input.internal_name) })
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
