# frozen_string_literal: true

module Servactory
  module Inputs
    class Collection < Servactory::Attributes::Collection
      def_delegators :@collection, :flat_map

      private

      def lookup_name(item)
        item.internal_name
      end
    end
  end
end
