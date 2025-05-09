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
      end
    end
  end
end
