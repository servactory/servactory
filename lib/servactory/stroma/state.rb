# frozen_string_literal: true

module Servactory
  module Stroma
    # Holds the complete Stroma state for a service class.
    #
    # ## Purpose
    #
    # Central container that stores:
    # - Hooks collection for before/after extension points
    # - Settings collection for extension-specific configuration
    #
    # Each service class has its own State instance, duplicated during
    # inheritance to ensure independent configuration.
    #
    # ## Usage
    #
    # Accessed via `stroma` method in service classes:
    #
    # ```ruby
    # class MyService < ApplicationService::Base
    #   # In ClassMethods:
    #   stroma.hooks.before(:actions)
    #   stroma.settings[:actions][:authorization][:method_name]
    # end
    # ```
    #
    # ## Integration
    #
    # Stored as @stroma instance variable on each service class.
    # Duplicated in DSL.inherited to provide inheritance isolation.
    class State
      # @!attribute [r] hooks
      #   @return [Hooks::Collection] The hooks collection for this class
      # @!attribute [r] settings
      #   @return [Settings::Collection] The settings collection for this class
      attr_reader :hooks, :settings

      # Creates a new State with empty collections.
      def initialize
        @hooks = Hooks::Collection.new
        @settings = Settings::Collection.new
      end

      # Creates a deep copy during inheritance.
      #
      # Ensures child classes have independent hooks and settings
      # that don't affect the parent class.
      #
      # @param original [State] The original state being duplicated
      # @return [void]
      def initialize_dup(original)
        super
        @hooks = original.instance_variable_get(:@hooks).dup
        @settings = original.instance_variable_get(:@settings).dup
      end
    end
  end
end
