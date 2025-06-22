# frozen_string_literal: true

module Servactory
  module Configuration
    module Actions
      module Aliases
        class Collection
          extend Forwardable
          def_delegators :@collection, :<<, :merge, :include?

          def initialize(*_args)
            @collection = Set.new
          end
        end
      end
    end
  end
end
