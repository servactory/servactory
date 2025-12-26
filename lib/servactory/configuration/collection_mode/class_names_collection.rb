# frozen_string_literal: true

module Servactory
  module Configuration
    module CollectionMode
      class ClassNamesCollection
        extend Forwardable

        def_delegators :@collection, :merge, :intersect?

        def initialize(collection)
          @collection = collection
        end

        def initialize_dup(original)
          super
          @collection = original.instance_variable_get(:@collection).dup
        end
      end
    end
  end
end
