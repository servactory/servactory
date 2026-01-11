# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      # Storage view for service internal values.
      #
      # ## Purpose
      #
      # Internals provides simple key-value storage for intermediate
      # service state. It references a shared storage hash.
      #
      # ## Important Notes
      #
      # - References Storage#internals hash directly
      # - Minimal interface: fetch and assign
      class Internals
        # Creates internals view with shared storage reference.
        #
        # @param storage_internals [Hash] Reference to Storage#internals
        # @return [Internals] New internals view
        def initialize(storage_internals)
          @arguments = storage_internals
        end

        # Retrieves value by name with default fallback.
        #
        # @param name [Symbol] Internal name
        # @param default_value [Object] Value if not found
        # @return [Object] Stored or default value
        def fetch(name, default_value)
          @arguments.fetch(name, default_value)
        end

        # Stores value by key.
        #
        # @param key [Symbol] Internal name
        # @param value [Object] Value to store
        # @return [Object] Stored value
        def assign(key, value)
          @arguments[key] = value
        end
      end
    end
  end
end
