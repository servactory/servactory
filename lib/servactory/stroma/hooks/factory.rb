# frozen_string_literal: true

module Servactory
  module Stroma
    module Hooks
      # DSL interface for registering hooks in extensions block.
      #
      # ## Purpose
      #
      # Provides the `before` and `after` methods used within the extensions
      # block to register hooks. Validates that target keys exist in Registry
      # before adding hooks.
      #
      # ## Usage
      #
      # ```ruby
      # class ApplicationService::Base < Servactory::Base
      #   extensions do
      #     before :actions, ValidationModule
      #     after :outputs, LoggingModule
      #   end
      # end
      # ```
      #
      # ## Integration
      #
      # Created by DSL.extensions method and receives instance_eval of the block.
      # Validates keys against Registry.keys and raises UnknownHookTarget
      # for invalid keys.
      class Factory
        # Creates a new factory for registering hooks.
        #
        # @param hooks [Collection] The hooks collection to add to
        def initialize(hooks)
          @hooks = hooks
        end

        # Registers one or more before hooks for a target key.
        #
        # @param key [Symbol] The registry key to hook before
        # @param extensions [Array<Module>] Extension modules to include
        # @raise [Exceptions::UnknownHookTarget] If key is not registered
        #
        # @example
        #   before :actions, ValidationModule, AuthorizationModule
        def before(key, *extensions)
          validate_key!(key)
          extensions.each { |extension| @hooks.add(:before, key, extension) }
        end

        # Registers one or more after hooks for a target key.
        #
        # @param key [Symbol] The registry key to hook after
        # @param extensions [Array<Module>] Extension modules to include
        # @raise [Exceptions::UnknownHookTarget] If key is not registered
        #
        # @example
        #   after :outputs, LoggingModule, AuditModule
        def after(key, *extensions)
          validate_key!(key)
          extensions.each { |extension| @hooks.add(:after, key, extension) }
        end

        private

        # Validates that the key exists in the Registry.
        #
        # @param key [Symbol] The key to validate
        # @raise [Exceptions::UnknownHookTarget] If key is not registered
        def validate_key!(key)
          return if Registry.key?(key)

          raise Exceptions::UnknownHookTarget,
                "Unknown hook target: #{key.inspect}. " \
                "Valid keys: #{Registry.keys.map(&:inspect).join(', ')}"
        end
      end
    end
  end
end
