# frozen_string_literal: true

module Servactory
  module Stroma
    # Dynamic key-value storage for extension configuration.
    #
    # ## Purpose
    #
    # Provides a Hash-based container for storing extension-specific
    # configuration data. Uses Forwardable delegation for consistent API.
    #
    # ## Usage
    #
    # ```ruby
    # config = Servactory::Stroma::ExtensionConfig.new
    # config[:method_name] = :authorize
    # config[:method_name]  # => :authorize
    # config.key?(:method_name)  # => true
    # ```
    #
    # ## Integration
    #
    # Used by RegistryKeyConfigs to store individual extension configs.
    # Properly duplicated during class inheritance via initialize_dup.
    class ExtensionConfig
      extend Forwardable

      def_delegators :@data, :[], :[]=, :key?, :keys, :each, :empty?, :size, :map

      def initialize(data = {})
        @data = data
      end

      def initialize_dup(original)
        super
        @data = deep_dup(original.instance_variable_get(:@data))
      end

      def to_h
        @data.dup
      end

      def fetch(key, *args, &block)
        @data.fetch(key.to_sym, *args, &block)
      end

      private

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
