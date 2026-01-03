# frozen_string_literal: true

module Servactory
  module Stroma
    # Main integration point between Stroma and service classes.
    #
    # ## Purpose
    #
    # Module that provides the core Stroma functionality to service classes:
    # - Includes all registered DSL modules
    # - Provides extensions block for hook registration
    # - Handles inheritance with proper state copying
    #
    # ## Usage
    #
    # ```ruby
    # class MyService
    #   include Servactory::Stroma::DSL
    #
    #   extensions do
    #     before :actions, MyExtension
    #   end
    # end
    # ```
    #
    # ## Extension Settings Access
    #
    # Extensions access their settings through the stroma.settings hierarchy:
    #
    # ```ruby
    # # In ClassMethods:
    # stroma.settings[:actions][:authorization][:method_name] = :authorize
    #
    # # In InstanceMethods:
    # self.class.stroma.settings[:actions][:authorization][:method_name]
    # ```
    #
    # ## Integration
    #
    # Included by Servactory::DSL which is included by Servactory::Base.
    # Provides ClassMethods with: stroma, inherited, extensions.
    module DSL
      def self.included(base)
        base.extend(ClassMethods)

        Registry.entries.each do |entry|
          base.include(entry.extension)
        end
      end

      # Class-level methods for Stroma integration.
      #
      # ## Purpose
      #
      # Provides access to Stroma state and hooks DSL at the class level.
      # Handles proper duplication during inheritance.
      #
      # ## Key Methods
      #
      # - `stroma` - Access the State container
      # - `inherited` - Copy state to child classes
      # - `extensions` - DSL block for hook registration
      module ClassMethods
        def self.extended(base)
          base.instance_variable_set(:@stroma, State.new)
        end

        # Handles inheritance by duplicating Stroma state.
        #
        # Creates an independent copy of hooks and settings for the child class,
        # then applies all registered hooks to the child.
        #
        # @param child [Class] The child class being created
        # @return [void]
        def inherited(child)
          super

          child.instance_variable_set(:@stroma, stroma.dup)

          Hooks::Applier.new(child, child.stroma.hooks).apply!
        end

        # Returns the Stroma state for this service class.
        #
        # @return [State] The Stroma state container
        #
        # @example Accessing hooks
        #   stroma.hooks.before(:actions)
        #
        # @example Accessing settings
        #   stroma.settings[:actions][:authorization][:method_name]
        def stroma
          @stroma ||= State.new
        end

        private

        # DSL block for registering hooks.
        #
        # Evaluates the block in the context of a Hooks::Factory,
        # allowing before/after hook registration.
        #
        # @yield Block with before/after DSL calls
        # @return [void]
        #
        # @example
        #   extensions do
        #     before :actions, AuthorizationExtension
        #     after :outputs, LoggingExtension
        #   end
        def extensions(&block)
          @stroma_hooks_factory ||= Hooks::Factory.new(stroma.hooks)
          @stroma_hooks_factory.instance_eval(&block)
        end
      end
    end
  end
end
