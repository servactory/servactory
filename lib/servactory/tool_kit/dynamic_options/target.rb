# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      # Validates that Class-typed attribute value matches one of the target classes.
      #
      # ## Purpose
      #
      # Target provides class matching validation for Class-typed attributes.
      # It ensures that the passed class is one of the specified target classes,
      # supporting both single class and arrays of acceptable classes.
      # This is useful for validating service classes, strategy patterns,
      # or any scenario where specific classes are expected.
      #
      # ## Usage
      #
      # This option is **NOT included by default**. Register it for each
      # attribute type where you want to use it:
      #
      # ```ruby
      # configuration do
      #   input_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::Target.use
      #   ])
      #
      #   internal_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::Target.use
      #   ])
      #
      #   output_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::Target.use
      #   ])
      # end
      # ```
      #
      # Use in your service definition:
      #
      # ```ruby
      # class ProcessOrderService < ApplicationService::Base
      #   input :service_class, type: Class, target: UserService
      #   input :handler_class, type: Class, target: [CreateHandler, UpdateHandler]
      # end
      # ```
      #
      # ## Simple Mode
      #
      # Specify target class directly or as an array:
      #
      # ```ruby
      # input :service_class, type: Class, target: UserService
      # input :handler_class, type: Class, target: [CreateHandler, UpdateHandler]
      # ```
      #
      # ## Advanced Mode
      #
      # Specify target with custom error message using a hash.
      # Note: Advanced mode uses `:in` key (not `:is`).
      #
      # With static message:
      #
      # ```ruby
      # input :handler_class, type: Class, target: {
      #   in: [CreateHandler, UpdateHandler],
      #   message: "Input `handler_class` must be one of: CreateHandler, UpdateHandler"
      # }
      # ```
      #
      # With dynamic lambda message:
      #
      # ```ruby
      # input :handler_class, type: Class, target: {
      #   in: [CreateHandler, UpdateHandler],
      #   message: lambda do |input:, value:, option_value:, **|
      #     "Input `#{input.name}` received `#{value}`, expected: #{Array(option_value).map(&:name).join(', ')}"
      #   end
      # }
      # ```
      #
      # Lambda receives the following parameters:
      # - For inputs: `input:, value:, option_value:, reason:, **`
      # - For internals: `internal:, value:, option_value:, reason:, **`
      # - For outputs: `output:, value:, option_value:, reason:, **`
      #
      # ## Validation Rules
      #
      # - Class must exactly match one of the target classes
      # - Supports single class or array of classes
      # - Optional inputs with nil value validate against default
      #
      # ## Important Notes
      #
      # - Use `target: { in: [...] }` syntax for specifying allowed values
      # - Returns `:invalid_option` error if target is nil
      # - For optional inputs with nil value and default, validates the default
      # - Internal/output attributes do NOT have default value handling (unlike inputs)
      # - For Class-typed attributes, arrays of classes are preserved as-is rather
      #   than being wrapped (e.g., `[User, Admin]` stays as array, not `[[User, Admin]]`)
      class Target < Must
        # Creates a Target validator instance.
        #
        # @param option_name [Symbol] The option name (default: :target)
        # @return [Servactory::Maintenance::Attributes::OptionHelper]
        def self.use(option_name = :target)
          instance = new(option_name, :in)
          instance.must(:"be_#{option_name}")
        end

        # Validates target condition for input attribute.
        #
        # @param input [Object] Input attribute object
        # @param value [Object] Value to validate
        # @param option [WorkOption] Target configuration
        # @return [Boolean, Array] true if valid, or [false, reason]
        def condition_for_input_with(input:, value:, option:) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
          return [false, :invalid_option] if option.value.nil?

          target_values = normalize_target_values(option.value, input.types)

          # Required inputs or optional with non-nil value.
          return target_values.include?(value) if input.required? || (input.optional? && !value.nil?)

          # Optional with nil value but has default.
          return target_values.include?(input.default) if input.optional? && value.nil? && !input.default.nil?

          true
        end

        # Validates target condition for internal attribute.
        #
        # @param internal [Object] Internal attribute object
        # @param value [Object] Value to validate
        # @param option [WorkOption] Target configuration
        # @return [Boolean, Array] true if valid, or [false, reason]
        def condition_for_internal_with(value:, option:, internal: nil, **)
          return [false, :invalid_option] if option.value.nil?

          target_values = normalize_target_values(option.value, internal.types)

          target_values.include?(value)
        end

        # Validates target condition for output attribute.
        #
        # @param output [Object] Output attribute object
        # @param value [Object] Value to validate
        # @param option [WorkOption] Target configuration
        # @return [Boolean, Array] true if valid, or [false, reason]
        def condition_for_output_with(value:, option:, output: nil, **)
          return [false, :invalid_option] if option.value.nil?

          target_values = normalize_target_values(option.value, output.types)

          target_values.include?(value)
        end

        ########################################################################

        # Generates error message for input validation failure.
        #
        # @param service [Object] Service context
        # @param input [Object] Input attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Expected target values
        # @param reason [Symbol] Failure reason
        # @return [String] Localized error message
        def message_for_input_with(service:, input:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "inputs.validations.must.dynamic_options.target"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            input_name: input.name,
            value: value.inspect,
            expected_target: option_value.inspect,
            option_name:
          )
        end

        # Generates error message for internal validation failure.
        #
        # @param service [Object] Service context
        # @param internal [Object] Internal attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Expected target values
        # @param reason [Symbol] Failure reason
        # @return [String] Localized error message
        def message_for_internal_with(service:, internal:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "internals.validations.must.dynamic_options.target"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            internal_name: internal.name,
            value: value.inspect,
            expected_target: option_value.inspect,
            option_name:
          )
        end

        # Generates error message for output validation failure.
        #
        # @param service [Object] Service context
        # @param output [Object] Output attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Expected target values
        # @param reason [Symbol] Failure reason
        # @return [String] Localized error message
        def message_for_output_with(service:, output:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "outputs.validations.must.dynamic_options.target"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            output_name: output.name,
            value: value.inspect,
            expected_target: option_value.inspect,
            option_name:
          )
        end

        private

        # Normalizes target values into array format.
        #
        # Handles special case for Class types where arrays should
        # be preserved as-is rather than wrapped.
        #
        # @param option_value [Object] Target value(s)
        # @param types [Array<Class>] Attribute types
        # @return [Array] Normalized array of target values
        def normalize_target_values(option_value, types)
          # Special handling for Class type attributes.
          if types.size == 1 && types.first == Class
            return [option_value] unless option_value.is_a?(Array)

            return option_value
          end

          option_value.is_a?(Array) ? option_value : [option_value]
        end
      end
    end
  end
end
