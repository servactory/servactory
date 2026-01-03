# frozen_string_literal: true

module Servactory
  module Stroma
    module Hooks
      # Valid hook types for Hook validation.
      VALID_HOOK_TYPES = %i[before after].freeze
      private_constant :VALID_HOOK_TYPES

      # Immutable value object representing a hook configuration.
      #
      # ## Purpose
      #
      # Defines when and where an extension module should be included
      # relative to a registered DSL module. Hook is immutable - once
      # created, it cannot be modified.
      #
      # ## Attributes
      #
      # @!attribute [r] type
      #   @return [Symbol] Either :before or :after
      # @!attribute [r] target_key
      #   @return [Symbol] Key of the DSL module to hook into (:inputs, :actions, etc.)
      # @!attribute [r] extension
      #   @return [Module] The module to include at the hook point
      #
      # ## Usage
      #
      # ```ruby
      # hook = Servactory::Stroma::Hooks::Hook.new(
      #   type: :before,
      #   target_key: :actions,
      #   extension: MyExtension
      # )
      # hook.before?  # => true
      # hook.after?   # => false
      # ```
      #
      # ## Immutability
      #
      # Hook is a Data object - frozen and immutable after creation.
      Hook = Data.define(:type, :target_key, :extension) do
        # Initializes a new Hook with validation.
        #
        # @param type [Symbol] Hook type (:before or :after)
        # @param target_key [Symbol] Registry key to hook into
        # @param extension [Module] Extension module to include
        # @raise [Exceptions::InvalidHookType] If type is invalid
        def initialize(type:, target_key:, extension:)
          if VALID_HOOK_TYPES.exclude?(type)
            raise Exceptions::InvalidHookType,
                  "Invalid hook type: #{type.inspect}. Valid types: #{VALID_HOOK_TYPES.map(&:inspect).join(', ')}"
          end

          super
        end

        # Checks if this is a before hook.
        #
        # @return [Boolean] true if type is :before
        def before?
          type == :before
        end

        # Checks if this is an after hook.
        #
        # @return [Boolean] true if type is :after
        def after?
          type == :after
        end
      end
    end
  end
end
