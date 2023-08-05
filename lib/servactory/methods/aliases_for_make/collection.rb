# frozen_string_literal: true

module Servactory
  module Methods
    module AliasesForMake
      class Collection
        extend Forwardable
        def_delegators :@collection, :<<, :merge, :include?

        def initialize(*)
          @collection = Set.new
        end
      end
    end
  end
end
