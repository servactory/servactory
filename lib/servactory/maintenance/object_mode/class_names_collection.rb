# frozen_string_literal: true

module Servactory
  module Maintenance
    module ObjectMode
      class ClassNamesCollection
        extend Forwardable
        def_delegators :@collection, :include?

        def initialize(collection)
          @collection = collection
        end
      end
    end
  end
end
