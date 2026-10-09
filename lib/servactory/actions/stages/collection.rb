# frozen_string_literal: true

module Servactory
  module Actions
    module Stages
      class Collection
        extend Forwardable

        def_delegators :@collection, :each, :to_h, :sort_by, :size, :empty?

        def initialize(collection = Set.new)
          @collection = collection
        end

        def initialize_dup(original)
          super
          @collection = original.instance_variable_get(:@collection).dup
          @sorted_by_position = nil
        end

        def <<(stage)
          @collection << stage
          @sorted_by_position = nil
          self
        end

        def merge(other)
          @collection.merge(other)
          @sorted_by_position = nil
          self
        end

        def sorted_by_position
          @sorted_by_position ||= Collection.new(sort_by(&:position))
        end
      end
    end
  end
end
