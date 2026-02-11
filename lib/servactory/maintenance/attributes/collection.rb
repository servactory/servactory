# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      class Collection
        extend Forwardable

        def_delegators :@collection, :<<, :filter, :each, :each_with_object, :map, :to_h, :merge, :find

        def initialize(collection = Set.new)
          @collection = collection
        end

        def names
          map(&:name)
        end

        def only(*names)
          self.class.new(filter { |attribute| names.include?(lookup_name(attribute)) })
        end

        def except(*names)
          self.class.new(filter { |attribute| names.exclude?(lookup_name(attribute)) })
        end

        def find_by(name:)
          attributes_index[name]
        end

        private

        def attributes_index
          @attributes_index ||= each_with_object({}) do |attribute, index|
            index[lookup_name(attribute)] = attribute
          end
        end

        def lookup_name(attribute)
          attribute.name
        end
      end
    end
  end
end
