# frozen_string_literal: true

module Servactory
  module Configuration
    module Actions
      module Shortcuts
        class Collection
          extend Forwardable
          def_delegators :@collection, :merge!, :fetch

          def initialize(*)
            @collection = {}
          end

          alias merge merge!

          def shortcuts
            flat_map(&:keys)
          end

          def find_by(name:)
            fetch(name, nil)
          end
        end
      end
    end
  end
end
