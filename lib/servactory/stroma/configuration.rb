# frozen_string_literal: true

module Servactory
  module Stroma
    # Per-class configuration storage for Stroma hooks.
    #
    # ## Purpose
    #
    # Holds the Hooks collection for each service class. Properly copied
    # during class inheritance to ensure independent hook collections.
    #
    # ## Usage
    #
    # ```ruby
    # config = Servactory::Stroma::Configuration.new
    # config.hooks.add(:before, :actions, MyModule)
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
      attr_reader :hooks

      def initialize
        @hooks = Hooks.new
      end

      def initialize_dup(original)
        super
        @hooks = original.instance_variable_get(:@hooks).dup
      end
    end
  end
end
