# frozen_string_literal: true

module Servactory
  module OldConfiguration
    module Actions
      module RescueHandlers
        class Collection
          extend Forwardable
          def_delegators :@collection, :+, :detect, :reverse_each

          def initialize(*)
            @collection = Set.new
          end
        end
      end
    end
  end
end
