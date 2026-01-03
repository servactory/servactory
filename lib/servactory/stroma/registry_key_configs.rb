# frozen_string_literal: true

module Servactory
  module Stroma
    # Collection of ExtensionConfig objects for one registry key.
    #
    # ## Purpose
    #
    # Groups extension configurations by registry key (e.g., :actions).
    # Provides auto-vivifying access to individual ExtensionConfig objects.
    #
    # ## Usage
    #
    # ```ruby
    # configs = Servactory::Stroma::RegistryKeyConfigs.new
    # configs[:authorization][:method_name] = :authorize
    # configs[:transactional][:enabled] = true
    #
    # configs.keys   # => [:authorization, :transactional]
    # configs.empty? # => false
    # ```
    #
    # ## Integration
    #
    # Used by ExtensionConfigs as second-level container.
    # Properly duplicated during class inheritance via initialize_dup.
    class RegistryKeyConfigs
      extend Forwardable

      def_delegators :@storage, :each, :keys, :size, :empty?, :map

      def initialize(storage = {})
        @storage = storage
      end

      def initialize_dup(original)
        super
        @storage = original.instance_variable_get(:@storage).transform_values(&:dup)
      end

      def [](extension_name)
        @storage[extension_name.to_sym] ||= ExtensionConfig.new
      end

      def to_h
        @storage.transform_values(&:to_h)
      end
    end
  end
end
