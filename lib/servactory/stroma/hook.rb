# frozen_string_literal: true

module Servactory
  module Stroma
    # Represents a hook configuration for extending service classes.
    #
    # ## Purpose
    #
    # Immutable value object that defines when and where an extension
    # module should be included relative to a registered DSL module.
    #
    # ## Attributes
    #
    # - `type` (Symbol): Either :before or :after
    # - `target_key` (Symbol): Key of the DSL module to hook into (:inputs, :actions, etc.)
    # - `extension` (Module): The module to include at the hook point
    #
    # ## Usage
    #
    # ```ruby
    # hook = Servactory::Stroma::Hook.new(type: :before, target_key: :actions, extension: MyExtension)
    # hook.before?  # => true
    # hook.after?   # => false
    # ```
    #
    # ## Immutability
    #
    # Hook is immutable (Data object) - once created, it cannot be modified.
    Hook = Data.define(:type, :target_key, :extension) do
      VALID_TYPES = %i[before after].freeze

      def initialize(type:, target_key:, extension:)
        unless VALID_TYPES.include?(type)
          raise Exceptions::InvalidHookType,
                "Invalid hook type: #{type.inspect}. Valid types: #{VALID_TYPES.map(&:inspect).join(', ')}"
        end

        super
      end

      def before?
        type == :before
      end

      def after?
        type == :after
      end
    end
  end
end
