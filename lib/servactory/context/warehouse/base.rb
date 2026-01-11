# frozen_string_literal: true

module Servactory
  module Context
    module Warehouse
      # Base class for warehouse storage views.
      #
      # ## Purpose
      #
      # Provides common fetch and assign operations for all warehouse
      # view classes (Inputs, Internals, Outputs).
      #
      # ## Important Notes
      #
      # - Accepts hash reference from Storage, not a copy
      # - Subclasses can override methods for specialized behavior
      class Base
        # Creates base view with storage hash reference.
        #
        # @param arguments [Hash] Reference to Storage hash
        # @return [Base] New base view
        def initialize(arguments = {})
          @arguments = arguments
        end

        # Retrieves value by name with default fallback.
        #
        # @param name [Symbol] Key name
        # @param default_value [Object] Value if not found
        # @return [Object] Stored or default value
        def fetch(name, default_value)
          @arguments.fetch(name, default_value)
        end

        # Stores value by key.
        #
        # @param key [Symbol] Key name
        # @param value [Object] Value to store
        # @return [Object] Stored value
        def assign(key, value)
          @arguments[key] = value
        end
      end
    end
  end
end
