# frozen_string_literal: true

module Servactory
  module Configuration
    module Actions
      module RescueHandlers
        class Collection
          extend Forwardable
          def_delegators :@collection, :+, :detect, :reverse_each

          def initialize(*_args)
            @collection = Set.new
          end
        end
      end
    end
  end
end
