# frozen_string_literal: true

module Servactory
  module OldConfiguration
    module HashMode
      class ClassNamesCollection
        extend Forwardable
        def_delegators :@collection, :include?, :intersect?

        def initialize(collection)
          @collection = collection
        end
      end
    end
  end
end
