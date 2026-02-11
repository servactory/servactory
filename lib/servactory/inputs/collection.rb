# frozen_string_literal: true

module Servactory
  module Inputs
    class Collection < Servactory::Maintenance::Attributes::Collection
      def_delegators :@collection, :flat_map

      private

      def lookup_name(attribute)
        attribute.internal_name
      end
    end
  end
end
