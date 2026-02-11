# frozen_string_literal: true

module Servactory
  module Inputs
    # Specialized collection for Input attributes.
    #
    # Overrides `lookup_name` to use `internal_name` instead of `name`,
    # supporting the `as:` parameter that renames inputs internally.
    # Adds `flat_map` delegation for input-specific enumeration needs.
    class Collection < Servactory::Maintenance::Attributes::Collection
      def_delegators :@collection, :flat_map

      private

      # Returns `internal_name` for indexing, supporting the `as:` parameter.
      #
      # @param attribute [Object] the input attribute
      # @return [Symbol] the internal name used for lookup
      def lookup_name(attribute)
        attribute.internal_name
      end
    end
  end
end
