# frozen_string_literal: true

module Servactory
  module Stroma
    module Settings
      # Dynamic key-value storage for extension configuration.
      #
      # ## Purpose
      #
      # Provides a Hash-based container for storing extension-specific
      # configuration data. Uses Forwardable delegation for consistent API.
      # This is the leaf-level container in the settings hierarchy.
      #
      # ## Usage
      #
      # ```ruby
      # setting = Servactory::Stroma::Settings::Setting.new
      # setting[:method_name] = :authorize
      # setting[:method_name]  # => :authorize
      # setting.key?(:method_name)  # => true
      # ```
      #
      # ## Integration
      #
      # Used by RegistrySettings to store individual extension settings.
      # Properly duplicated during class inheritance via initialize_dup.
      class Setting
        extend Forwardable

        # @!method [](key)
        #   Retrieves a value by key.
        #   @param key [Symbol] The key to look up
        #   @return [Object, nil] The stored value or nil
        # @!method []=(key, value)
        #   Stores a value by key.
        #   @param key [Symbol] The key to store under
        #   @param value [Object] The value to store
        # @!method key?(key)
        #   Checks if a key exists.
        #   @param key [Symbol] The key to check
        #   @return [Boolean] true if key exists
        # @!method keys
        #   Returns all stored keys.
        #   @return [Array<Symbol>] List of keys
        # @!method each
        #   Iterates over all key-value pairs.
        #   @yield [key, value] Each stored pair
        # @!method empty?
        #   Checks if no values are stored.
        #   @return [Boolean] true if empty
        # @!method size
        #   Returns the number of stored values.
        #   @return [Integer] Number of entries
        # @!method map
        #   Maps over all key-value pairs.
        #   @yield [key, value] Each stored pair
        #   @return [Array] Mapped results
        def_delegators :@data, :[], :[]=, :key?, :keys, :each, :empty?, :size, :map

        # Creates a new setting container.
        #
        # @param data [Hash] Initial data (default: empty Hash)
        def initialize(data = {})
          @data = data
        end

        # Creates a deep copy during inheritance.
        #
        # @param original [Setting] The original setting being duplicated
        # @return [void]
        def initialize_dup(original)
          super
          @data = deep_dup(original.instance_variable_get(:@data))
        end

        # Converts to a plain Hash.
        #
        # @return [Hash] Deep copy of internal data
        def to_h
          deep_dup(@data)
        end

        # Fetches a value with optional default.
        #
        # @param key [Symbol] The key to fetch
        # @param args [Array] Optional default value
        # @yield Optional block for default value
        # @return [Object] The fetched value or default
        #
        # @example
        #   setting.fetch(:method_name, :default_method)
        #   setting.fetch(:method_name) { :computed_default }
        def fetch(key, *args, &block)
          @data.fetch(key.to_sym, *args, &block)
        end

        private

        # Recursively duplicates nested Hash and Array structures.
        #
        # @param obj [Object] The object to duplicate
        # @return [Object] Deep copy of the object
        def deep_dup(obj)
          case obj
          when Hash then obj.transform_values { |v| deep_dup(v) }
          when Array then obj.map { |v| deep_dup(v) }
          else obj.respond_to?(:dup) ? obj.dup : obj
          end
        end
      end
    end
  end
end
