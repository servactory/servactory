# frozen_string_literal: true

module Servactory
  module Extensions
    class Collection
      extend Forwardable
      def_delegators :@collection, :<<, :each, :merge

      def initialize(collection = Set.new)
        @collection = collection
      end
    end
  end
end
