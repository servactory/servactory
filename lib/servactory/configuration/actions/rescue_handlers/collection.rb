# frozen_string_literal: true

module Servactory
  module Configuration
    module Actions
      module RescueHandlers
        class Collection
          extend Forwardable

          def_delegators :@collection, :+, :detect, :reverse_each

          def initialize(*)
            @collection = Set.new
          end

          def initialize_dup(original)
            super
            @collection = original.instance_variable_get(:@collection).dup
          end
        end
      end
    end
  end
end
