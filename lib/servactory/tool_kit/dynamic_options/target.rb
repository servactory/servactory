# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      # Validates that attribute value matches one of the target values.
      #
      # ## Purpose
      #
      # Target provides exact value matching validation for attributes.
      # It ensures that the value is one of the specified target values,
      # supporting both single values and arrays of acceptable values.
      # This is useful for enum-like validations where only specific
      # values are allowed.
      #
      # ## Usage
      #
      # Register the option in your service configuration:
      #
      # ```ruby
      # configuration do
      #   input_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::Target.use
      #   ])
      # end
      # ```
      #
      # Use in your service definition:
      #
      # ```ruby
      # class ProcessOrderService < ApplicationService::Base
      #   input :status, type: Symbol, target: { in: [:pending, :processing, :complete] }
      #   input :priority, type: Integer, target: { in: [1, 2, 3] }
      #   input :model_class, type: Class, target: { in: [User, Admin] }
      # end
      # ```
      #
      # ## Validation Rules
      #
      # - Value must exactly match one of the target values
      # - Supports single value or array of values
      # - For Class types, special handling preserves array structure
      # - Optional inputs with nil value validate against default
      #
      # ## Important Notes
      #
      # - Use `target: { in: [...] }` syntax for specifying allowed values
      # - Returns `:invalid_option` error if target is nil
      # - For optional inputs with nil value and default, validates the default
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
