# frozen_string_literal: true

module Servactory
  module Stroma
    # DSL interface for creating hooks in extensions block.
    #
    # ## Purpose
    #
    # Provides the `before` and `after` methods used within the extensions
    # block to register hooks. Validates that target keys exist in Registry.
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
    # Created by DSL.extensions and receives instance_eval of the block.
    # Validates keys against Registry.keys and raises UnknownHookTarget
    # for invalid keys.
    class HooksFactory
      def initialize(hooks)
        @hooks = hooks
      end

      def before(key, *extensions)
        validate_key!(key)
        extensions.each { |extension| @hooks.add(:before, key, extension) }
      end

      def after(key, *extensions)
        validate_key!(key)
        extensions.each { |extension| @hooks.add(:after, key, extension) }
      end

      private

      def validate_key!(key)
        return if Registry.key?(key)

        raise Exceptions::UnknownHookTarget,
              "Unknown hook target: #{key.inspect}. " \
              "Valid keys: #{Registry.keys.map(&:inspect).join(', ')}"
      end
    end
  end
end
