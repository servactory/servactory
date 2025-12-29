# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      # Validates that attribute value is included in a specified set.
      #
      # ## Purpose
      #
      # Inclusion provides set membership validation for attributes.
      # It ensures that the value is present within a predefined list
      # of acceptable values. This is similar to ActiveModel's inclusion
      # validation and is useful for enum-like constraints.
      #
      # ## Usage
      #
      # This option is **included by default** for inputs, internals, and outputs.
      # No registration required.
      #
      # Use in your service definition:
      #
      # ```ruby
      # class CreateUserService < ApplicationService::Base
      #   input :role, type: String, inclusion: { in: %w[admin user guest] }
      #   input :status, type: Symbol, inclusion: { in: [:active, :inactive] }
      #   input :level, type: Integer, inclusion: { in: [1, 2, 3, 4, 5] }
      # end
      # ```
      #
      # ## Validation Rules
      #
      # - Value must be present in the inclusion list
      # - Supports arrays as inclusion sets
      # - Optional inputs with nil value validate against default
      # - Returns `:invalid_option` error if inclusion set is nil
      #
      # ## Important Notes
      #
      # - Use `inclusion: { in: [...] }` syntax for specifying allowed values
      # - Single values are automatically wrapped in an array
      # - For optional inputs with nil value, validates default if present
      # - Range objects ARE supported natively: `(1..10)`, `(1..)`, `(..100)`
      # - Mixed syntax supported: `[1..5, 10, 15..20]` checks value against all elements
      class Inclusion < Must
        # Creates an Inclusion validator instance.
        #
        # @param option_name [Symbol] The option name (default: :inclusion)
        # @return [Servactory::Maintenance::Attributes::OptionHelper]
        def self.use(option_name = :inclusion)
          instance = new(option_name, :in)
          instance.must(:be_inclusion)
        end

        # Validates inclusion condition for input attribute.
        #
        # @param input [Object] Input attribute object
        # @param value [Object] Value to validate
        # @param option [WorkOption] Inclusion configuration
        # @return [Boolean, Array] true if valid, or [false, reason]
        def condition_for_input_with(input:, value:, option:) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
          return [false, :invalid_option] if option.value.nil?

          inclusion_values = normalize_inclusion_values(option.value)

          # Required inputs or optional with non-nil value.
          if input.required? || (input.optional? && !value.nil?) # rubocop:disable Style/IfUnlessModifier
            return value_in_inclusion?(inclusion_values, value)
          end

          # Optional with nil value but has default.
          if input.optional? && value.nil? && !input.default.nil?
            return value_in_inclusion?(inclusion_values, input.default)
          end

          true
        end

        # Validates inclusion condition for internal attribute.
        #
        # @param value [Object] Value to validate
        # @param option [WorkOption] Inclusion configuration
        # @return [Boolean, Array] true if valid, or [false, reason]
        def condition_for_internal_with(value:, option:, **)
          return [false, :invalid_option] if option.value.nil?

          inclusion_values = normalize_inclusion_values(option.value)
          value_in_inclusion?(inclusion_values, value)
        end

        # Validates inclusion condition for output attribute.
        #
        # @param value [Object] Value to validate
        # @param option [WorkOption] Inclusion configuration
        # @return [Boolean, Array] true if valid, or [false, reason]
        def condition_for_output_with(value:, option:, **)
          return [false, :invalid_option] if option.value.nil?

          inclusion_values = normalize_inclusion_values(option.value)
          value_in_inclusion?(inclusion_values, value)
        end

        ########################################################################

        # Generates error message for input validation failure.
        #
        # @param service [Object] Service context
        # @param input [Object] Input attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Allowed values
        # @param reason [Symbol] Failure reason
        # @return [String] Localized error message
        def message_for_input_with(service:, input:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "inputs.validations.must.dynamic_options.inclusion"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            input_name: input.name,
            value: value.inspect,
            input_inclusion: option_value.inspect,
            option_name:
          )
        end

        # Generates error message for internal validation failure.
        #
        # @param service [Object] Service context
        # @param internal [Object] Internal attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Allowed values
        # @param reason [Symbol] Failure reason
        # @return [String] Localized error message
        def message_for_internal_with(service:, internal:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "internals.validations.must.dynamic_options.inclusion"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            internal_name: internal.name,
            value: value.inspect,
            internal_inclusion: option_value.inspect,
            option_name:
          )
        end

        # Generates error message for output validation failure.
        #
        # @param service [Object] Service context
        # @param output [Object] Output attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Allowed values
        # @param reason [Symbol] Failure reason
        # @return [String] Localized error message
        def message_for_output_with(service:, output:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "outputs.validations.must.dynamic_options.inclusion"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            output_name: output.name,
            value: value.inspect,
            output_inclusion: option_value.inspect,
            option_name:
          )
        end

        private

        # Normalizes inclusion values, preserving Range objects.
        #
        # @param option_value [Range, Array, Object] Inclusion value(s)
        # @return [Range, Array] Range preserved as-is, others normalized to array
        def normalize_inclusion_values(option_value)
          case option_value
          when Range, Array then option_value
          else [option_value]
          end
        end

        # Checks if value is included in the normalized inclusion values.
        #
        # @param inclusion_values [Range, Array] Normalized inclusion set
        # @param value [Object] Value to check
        # @return [Boolean] true if value is in inclusion set
        def value_in_inclusion?(inclusion_values, value)
          case inclusion_values
          when Range
            range_covers?(inclusion_values, value)
          when Array
            inclusion_values.any? { |element| element_matches?(element, value) }
          else
            inclusion_values == value
          end
        end

        # Checks if value matches a single element (Range or scalar).
        #
        # @param element [Range, Object] Element to match against
        # @param value [Object] Value to check
        # @return [Boolean] true if matches
        def element_matches?(element, value)
          element.is_a?(Range) ? range_covers?(element, value) : element == value
        end

        # Safely checks if Range covers the value.
        #
        # @param range [Range] Range to check against
        # @param value [Object] Value to check
        # @return [Boolean] true if range covers value, false on type errors
        def range_covers?(range, value)
          return false if value.nil?

          range.cover?(value)
        rescue ArgumentError, TypeError
          false
        end
      end
    end
  end
end
