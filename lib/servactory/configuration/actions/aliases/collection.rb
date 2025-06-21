# frozen_string_literal: true

module Servactory
  module Configuration
    module Actions
      module Aliases
        class Collection
          extend Forwardable
          def_delegators :@collection, :merge, :merge!, :fetch, :[], :include?

          def initialize(*)
            @collection = {}
          end
        end
      end
    end
  end
end
