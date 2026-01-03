# frozen_string_literal: true

module Servactory
  module Stroma
    module Settings
      # Top-level hierarchical container for extension settings.
      #
      # ## Purpose
      #
      # Provides two-level hierarchical access to extension settings:
      # registry_key -> extension_name -> setting values.
      # Auto-vivifies RegistrySettings on first access.
      #
      # ## Usage
      #
      # ```ruby
      # settings = Servactory::Stroma::Settings::Collection.new
      # settings[:actions][:authorization][:method_name] = :authorize
      # settings[:actions][:transactional][:enabled] = true
      #
      # settings.keys    # => [:actions]
      # settings.empty?  # => false
      # settings.to_h    # => { actions: { authorization: { method_name: :authorize }, ... } }
      # ```
      #
      # ## Integration
      #
      # Stored in Servactory::Stroma::State alongside Hooks::Collection.
      # Accessed via `stroma.settings` in service classes.
      # Properly duplicated during class inheritance via initialize_dup.
      class Collection
        extend Forwardable

        # @!method each
        #   Iterates over all registry key settings.
        #   @yield [key, settings] Each registry key and its RegistrySettings
        # @!method keys
        #   Returns all registry keys with settings.
        #   @return [Array<Symbol>] List of registry keys
        # @!method size
        #   Returns the number of registry keys configured.
        #   @return [Integer] Number of registry keys
        # @!method empty?
        #   Checks if no settings are configured.
        #   @return [Boolean] true if empty
        # @!method map
        #   Maps over all registry key settings.
        #   @yield [key, settings] Each registry key and its RegistrySettings
        #   @return [Array] Mapped results
        def_delegators :@storage, :each, :keys, :size, :empty?, :map

        # Creates a new settings collection.
        #
        # @param storage [Hash] Initial storage (default: empty Hash)
        def initialize(storage = {})
          @storage = storage
        end

        # Creates a deep copy during inheritance.
        #
        # @param original [Collection] The original collection being duplicated
        # @return [void]
        def initialize_dup(original)
          super
          @storage = original.instance_variable_get(:@storage).transform_values(&:dup)
        end

        # Accesses or creates RegistrySettings for a registry key.
        #
        # Auto-vivifies a new RegistrySettings on first access.
        #
        # @param registry_key [Symbol] The registry key (e.g., :actions)
        # @return [RegistrySettings] Settings for that registry key
        #
        # @example
        #   settings[:actions][:authorization][:method_name] = :authorize
        def [](registry_key)
          @storage[registry_key.to_sym] ||= RegistrySettings.new
        end

        # Converts to a nested Hash.
        #
        # @return [Hash] Deep nested hash of all settings
        def to_h
          @storage.transform_values(&:to_h)
        end
      end
    end
  end
end
