# frozen_string_literal: true

module Servactory
  module Stroma
    # Per-class configuration storage for Stroma hooks and extension configs.
    #
    # ## Purpose
    #
    # Holds the Hooks collection and ExtensionConfigs for each service class.
    # Properly copied during class inheritance to ensure independent collections.
    #
    # ## Usage
    #
    # ```ruby
    # config = Servactory::Stroma::Configuration.new
    # config.hooks.add(:before, :actions, MyModule)
    # config.extension_configs[:actions][:authorization][:method_name] = :authorize
    #
    # # During inheritance:
    # child_config = config.dup  # Creates independent copy
    # ```
    #
    # ## Integration
    #
    # Stored as @stroma instance variable on each service class.
    # Duplicated in DSL.inherited to provide inheritance isolation.
    class Configuration
      attr_reader :hooks, :extension_configs

      def initialize
        @hooks = Hooks.new
        @extension_configs = ExtensionConfigs.new
      end

      def initialize_dup(original)
        super
        @hooks = original.instance_variable_get(:@hooks).dup
        @extension_configs = original.instance_variable_get(:@extension_configs).dup
      end
    end
  end
end
