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
    # - Handles inheritance with proper configuration copying
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

      module ClassMethods
        def self.extended(base)
          base.instance_variable_set(:@stroma, Configuration.new)
        end

        def inherited(child)
          super

          child.instance_variable_set(:@stroma, stroma.dup)

          Applier.new(child, child.stroma.hooks).apply!
        end

        def stroma
          @stroma ||= Configuration.new
        end

        # Access extension configuration by registry key and extension name.
        #
        # @param registry_key [Symbol] Registry key (e.g., :actions, :inputs)
        # @param extension_name [Symbol] Extension identifier (e.g., :authorization)
        # @return [ExtensionConfig] Configuration container for the extension
        #
        # @example Setting configuration
        #   extension_config(:actions, :authorization)[:method_name] = :authorize
        #
        # @example Reading configuration
        #   method_name = extension_config(:actions, :authorization)[:method_name]
        def extension_config(registry_key, extension_name)
          stroma.extension_configs[registry_key][extension_name]
        end

        private

        def extensions(&block)
          @stroma_hooks_factory ||= HooksFactory.new(stroma.hooks)
          @stroma_hooks_factory.instance_eval(&block)
        end
      end
    end
  end
end
