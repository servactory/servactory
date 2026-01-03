# frozen_string_literal: true

module Servactory
  module Stroma
    # Top-level hierarchical container for extension configurations.
    #
    # ## Purpose
    #
    # Provides two-level hierarchical access to extension configurations:
    # registry_key -> extension_name -> config values.
    # Auto-vivifies RegistryKeyConfigs on first access.
    #
    # ## Usage
    #
    # ```ruby
    # configs = Servactory::Stroma::ExtensionConfigs.new
    # configs[:actions][:authorization][:method_name] = :authorize
    # configs[:actions][:transactional][:enabled] = true
    #
    # configs.keys    # => [:actions]
    # configs.empty?  # => false
    # configs.to_h    # => { actions: { authorization: { method_name: :authorize }, ... } }
    # ```
    #
    # ## Integration
    #
    # Stored in Servactory::Stroma::Configuration alongside Hooks.
    # Properly duplicated during class inheritance via initialize_dup.
    class ExtensionConfigs
      extend Forwardable

      def_delegators :@storage, :each, :keys, :size, :empty?, :map

      def initialize(storage = {})
        @storage = storage
      end

      def initialize_dup(original)
        super
        @storage = original.instance_variable_get(:@storage).transform_values(&:dup)
      end

      def [](registry_key)
        @storage[registry_key.to_sym] ||= RegistryKeyConfigs.new
      end

      def to_h
        @storage.transform_values(&:to_h)
      end
    end
  end
end
