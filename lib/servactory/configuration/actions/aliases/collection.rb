# frozen_string_literal: true

module Servactory
  module Configuration
    module Actions
      module Aliases
        class Collection
          extend Forwardable
          def_delegators :@collection, :<<, :include?

          def initialize(*)
            @collection = Set.new
          end

          def merge(aliases)
            @collection.merge(aliases)

            self
          end
        end
      end
    end
  end
end
