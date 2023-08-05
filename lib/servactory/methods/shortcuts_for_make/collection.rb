# frozen_string_literal: true

module Servactory
  module Methods
    module ShortcutsForMake
      class Collection
        extend Forwardable
        def_delegators :@collection, :<<, :each, :merge, :include?

        def initialize(*)
          @collection = Set.new
        end
      end
    end
  end
end
