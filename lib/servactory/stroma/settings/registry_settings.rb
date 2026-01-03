# frozen_string_literal: true

module Servactory
  module Stroma
    module Settings
      # Collection of Setting objects for one registry key.
      #
      # ## Purpose
      #
      # Groups extension settings by registry key (e.g., :actions).
      # Provides auto-vivifying access to individual Setting objects.
      # This is the middle layer in the settings hierarchy.
      #
      # ## Usage
      #
      # ```ruby
      # settings = Servactory::Stroma::Settings::RegistrySettings.new
      # settings[:authorization][:method_name] = :authorize
      # settings[:transactional][:enabled] = true
      #
      # settings.keys   # => [:authorization, :transactional]
      # settings.empty? # => false
      # ```
      #
      # ## Integration
      #
      # Used by Collection as second-level container.
      # Properly duplicated during class inheritance via initialize_dup.
      class RegistrySettings
        extend Forwardable

        # @!method each
        #   Iterates over all extension settings.
        #   @yield [name, setting] Each extension name and its Setting
        # @!method keys
        #   Returns all extension names.
        #   @return [Array<Symbol>] List of extension names
        # @!method size
        #   Returns the number of extensions configured.
        #   @return [Integer] Number of extensions
        # @!method empty?
        #   Checks if no extensions are configured.
        #   @return [Boolean] true if empty
        # @!method map
        #   Maps over all extension settings.
        #   @yield [name, setting] Each extension name and its Setting
        #   @return [Array] Mapped results
        def_delegators :@storage, :each, :keys, :size, :empty?, :map

        # Creates a new registry settings container.
        #
        # @param storage [Hash] Initial storage (default: empty Hash)
        def initialize(storage = {})
          @storage = storage
        end

        # Creates a deep copy during inheritance.
        #
        # @param original [RegistrySettings] The original being duplicated
        # @return [void]
        def initialize_dup(original)
          super
          @storage = original.instance_variable_get(:@storage).transform_values(&:dup)
        end

        # Accesses or creates a Setting for an extension.
        #
        # Auto-vivifies a new Setting on first access.
        #
        # @param extension_name [Symbol] The extension name
        # @return [Setting] The extension's setting container
        #
        # @example
        #   settings[:authorization][:method_name] = :authorize
        def [](extension_name)
          @storage[extension_name.to_sym] ||= Setting.new
        end

        # Converts to a nested Hash.
        #
        # @return [Hash] Nested hash of all settings
        def to_h
          @storage.transform_values(&:to_h)
        end
      end
    end
  end
end
