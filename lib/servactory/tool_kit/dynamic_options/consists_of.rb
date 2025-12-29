# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      # Validates that collection elements are of specified types.
      #
      # ## Purpose
      #
      # ConsistsOf ensures that all elements within an Array or collection
      # attribute match one of the specified types. This is essential for
      # validating homogeneous collections where each element must conform
      # to expected types.
      #
      # ## Usage
      #
      # This option is **included by default** for inputs, internals, and outputs.
      # No registration required for basic usage.
      #
      # To extend supported collection types (e.g., add `ActiveRecord::Relation`),
      # use the `collection_mode_class_names` configuration:
      #
      # ```ruby
      # configuration do
      #   collection_mode_class_names([ActiveRecord::Relation])
      # end
      # ```
      #
      # Use in your service definition:
      #
      # ```ruby
      # class ProcessUsersService < ApplicationService::Base
      #   input :user_ids, type: Array, consists_of: Integer
      #   input :tags, type: Array, consists_of: [String, Symbol]
      #   input :scores, type: Array, consists_of: Float
      # end
      # ```
      #
      # ## Validation Rules
      #
      # - Collection must be of a registered collection type (Array, Set, etc.)
      # - All elements are flattened before validation (nested arrays supported)
      # - Empty collections pass validation for optional input attributes only
      # - For internal/output attributes, presence check is always performed
      # - For optional inputs with non-empty collections, presence check is performed
      # - Multiple types can be specified as an array
      #
      # ## Important Notes
      #
      # - Use `consists_of: false` to disable validation
      # - NilClass in types allows nil elements in the collection
      # - Nested arrays are automatically flattened for validation
      class ConsistsOf < Must
        # Creates a ConsistsOf validator instance.
        #
        # @param option_name [Symbol] The option name (default: :consists_of)
        # @param collection_mode_class_names [Array<Class>] Valid collection types
        # @return [Servactory::Maintenance::Attributes::OptionHelper]
        def self.use(option_name = :consists_of, collection_mode_class_names:)
          instance = new(option_name, :type, false)
          instance.assign(collection_mode_class_names)
          instance.must(:consists_of)
        end

        # Assigns the list of valid collection class names.
        #
        # @param collection_mode_class_names [Array<Class>] Collection types to accept
        # @return [void]
        def assign(collection_mode_class_names)
          @collection_mode_class_names = collection_mode_class_names
        end

        # Validates element types for input attribute.
        #
        # @param input [Object] Input attribute object
        # @param value [Object] Collection value to validate
        # @param option [WorkOption] Type configuration
        # @return [Boolean, Array] true if valid, or [false, reason]
        def condition_for_input_with(input:, value:, option:)
          common_condition_with(attribute: input, value:, option:)
        end

        # Validates element types for internal attribute.
        #
        # @param internal [Object] Internal attribute object
        # @param value [Object] Collection value to validate
        # @param option [WorkOption] Type configuration
        # @return [Boolean, Array] true if valid, or [false, reason]
        def condition_for_internal_with(internal:, value:, option:)
          common_condition_with(attribute: internal, value:, option:)
        end

        # Validates element types for output attribute.
        #
        # @param output [Object] Output attribute object
        # @param value [Object] Collection value to validate
        # @param option [WorkOption] Type configuration
        # @return [Boolean, Array] true if valid, or [false, reason]
        def condition_for_output_with(output:, value:, option:)
          common_condition_with(attribute: output, value:, option:)
        end

        # Common validation logic for all attribute types.
        #
        # @param attribute [Object] The attribute being validated
        # @param value [Object] Collection value to validate
        # @param option [WorkOption] Type configuration
        # @return [Boolean, Array] true if valid, or [false, reason]
        def common_condition_with(attribute:, value:, option:)
          # Validation disabled.
          return true if option.value == false

          # Attribute must be a collection type.
          return [false, :wrong_type] unless @collection_mode_class_names.intersect?(attribute.types)

          # Flatten nested arrays for uniform validation.
          values = value.respond_to?(:flatten) ? value&.flatten : value

          validate_for!(attribute:, values:, option:)
        end

        # Validates all elements against allowed types.
        #
        # @param attribute [Object] The attribute being validated
        # @param values [Array] Flattened collection elements
        # @param option [WorkOption] Type configuration
        # @return [Boolean, Array] true if valid, or [false, reason]
        def validate_for!(attribute:, values:, option:)
          consists_of_types = Array(option.value).uniq

          # Check presence requirements.
          return [false, :required] if fails_presence_validation?(attribute:, values:, consists_of_types:)

          # Empty optional collections are valid.
          return true if values.blank? && attribute.input? && attribute.optional?

          # Verify each element matches allowed types.
          return true if values.all? do |value|
            consists_of_types.include?(value.class)
          end

          [false, :wrong_element_type]
        end

        # Checks if collection fails presence validation.
        #
        # @param attribute [Object] The attribute being validated
        # @param values [Array] Collection elements
        # @param consists_of_types [Array<Class>] Allowed types
        # @return [Boolean] true if validation fails
        def fails_presence_validation?(attribute:, values:, consists_of_types:)
          # NilClass in types allows nil elements.
          return false if consists_of_types.include?(NilClass)

          check_present = proc { _1 && !values.all?(&:present?) }

          [
            check_present[attribute.input? && (attribute.required? || (attribute.optional? && values.present?))],
            check_present[attribute.internal?],
            check_present[attribute.output?]
          ].any?
        end

        ########################################################################

        # Generates error message for input validation failure.
        #
        # @param service [Object] Service context
        # @param input [Object] Input attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Expected types
        # @param reason [Symbol] Failure reason
        # @return [String] Localized error message
        def message_for_input_with(service:, input:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "inputs.validations.must.dynamic_options.consists_of"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            service_class_name: service.class_name,
            input_name: input.name,
            option_name:,
            expected_type: Array(option_value).uniq.join(", "),
            given_type: given_type_for(values: value, option_value:)
          )
        end

        # Generates error message for internal validation failure.
        #
        # @param service [Object] Service context
        # @param internal [Object] Internal attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Expected types
        # @param reason [Symbol] Failure reason
        # @return [String] Localized error message
        def message_for_internal_with(service:, internal:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "internals.validations.must.dynamic_options.consists_of"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            service_class_name: service.class_name,
            internal_name: internal.name,
            option_name:,
            expected_type: Array(option_value).uniq.join(", "),
            given_type: given_type_for(values: value, option_value:)
          )
        end

        # Generates error message for output validation failure.
        #
        # @param service [Object] Service context
        # @param output [Object] Output attribute
        # @param value [Object] Failed value
        # @param option_name [Symbol] Option name
        # @param option_value [Object] Expected types
        # @param reason [Symbol] Failure reason
        # @return [String] Localized error message
        def message_for_output_with(service:, output:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "outputs.validations.must.dynamic_options.consists_of"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            service_class_name: service.class_name,
            output_name: output.name,
            option_name:,
            expected_type: Array(option_value).uniq.join(", "),
            given_type: given_type_for(values: value, option_value:)
          )
        end

        # Extracts type names of elements that don't match expected types.
        #
        # @param values [Array, nil] Collection elements
        # @param option_value [Object] Expected types
        # @return [String] Comma-separated list of unexpected type names
        def given_type_for(values:, option_value:)
          return "NilClass" if values.nil?

          values = values&.flatten if values.respond_to?(:flatten)

          values.filter { |value| Array(option_value).uniq.exclude?(value.class) }.map(&:class).uniq.join(", ")
        end
      end
    end
  end
end
