# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      class Collection
        extend Forwardable

        def_delegators :@collection, :<<, :filter, :each, :map, :to_h, :merge, :find

        def initialize(collection = Set.new)
          @collection = collection
        end

        def names
          map(&:name)
        end

        def only(*names)
          self.class.new(filter { |item| names.include?(lookup_name(item)) })
        end

        def except(*names)
          self.class.new(filter { |item| names.exclude?(lookup_name(item)) })
        end

        def find_by(name:)
          find { |item| lookup_name(item) == name }
        end

        private

        def lookup_name(item)
          item.name
        end
      end
    end
  end
end
