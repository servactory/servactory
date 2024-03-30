# frozen_string_literal: true

module Servactory
  module Actions
    module RescueHandlers
      class Collection
        extend Forwardable
        def_delegators :@collection, :+, :detect # :each, :merge

        def initialize(*)
          @collection = Set.new
        end
      end
    end
  end
end
