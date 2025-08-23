# frozen_string_literal: true

module Servactory
  module Configuration
    module Actions
      module Shortcuts
        class Collection
          extend Forwardable

          def_delegators :@collection, :merge!, :fetch, :keys

          def initialize(*)
            @collection = {}
          end

          alias merge merge!

          def shortcuts
            keys
          end

          def find_by(name:)
            fetch(name, nil)
          end
        end
      end
    end
  end
end
