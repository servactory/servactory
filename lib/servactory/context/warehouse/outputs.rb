# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      # Storage view for service output values.
      #
      # ## Purpose
      #
      # Outputs provides storage for service result values with iteration
      # support via each_pair delegation. Used by Result class to build
      # output hash.
      #
      # ## Important Notes
      #
      # - References Storage#outputs hash directly
      # - Delegates each_pair for Result building
      class Outputs
        extend Forwardable

        # Creates outputs view with shared storage reference.
        #
        # @param storage_outputs [Hash] Reference to Storage#outputs
        # @return [Outputs] New outputs view
        def initialize(storage_outputs)
          @arguments = storage_outputs
        end

        def_delegators :@arguments, :each_pair

        # Retrieves value by name with default fallback.
        #
        # @param name [Symbol] Output name
        # @param default_value [Object] Value if not found
        # @return [Object] Stored or default value
        def fetch(name, default_value)
          @arguments.fetch(name, default_value)
        end

        # Stores value by key.
        #
        # @param key [Symbol] Output name
        # @param value [Object] Value to store
        # @return [Object] Stored value
        def assign(key, value)
          @arguments[key] = value
        end
      end
    end
  end
end
