# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      # Validates Hash structures against a defined schema.
      #
      # ## Purpose
      #
      # Schema provides deep validation for Hash-type attributes by checking
      # that nested keys exist with correct types. It supports required/optional
      # fields, default values, and nested object validation. This is essential
      # for validating complex data structures like API payloads or configurations.
      #
      # ## Usage
      #
      # Register the schema option in your service configuration:
      #
      # ```ruby
      # configuration do
      #   input_option_helpers([
      #     Servactory::ToolKit::DynamicOptions::Schema.use(
      #       default_hash_mode_class_names: [Hash]
      #     )
      #   ])
      # end
      # ```
      #
      # Define schema in your service:
      #
      # ```ruby
      # class CreateUserService < ApplicationService::Base
      #   input :user_data,
      #         type: Hash,
      #         schema: {
      #           name: { type: String },
      #           age: { type: Integer, required: false, default: 18 },
      #           address: {
      #             type: Hash,
      #             street: { type: String },
      #             city: { type: String, required: false }
      #           }
      #         }
      # end
      # ```
      #
      # ## Schema Options
      #
      # Each field in the schema supports:
      # - `type` - Expected type (String, Integer, Array, Hash, etc.)
      # - `required` - Whether field is required (default: true)
      # - `default` - Default value when field is missing
      # - `prepare` - Proc to transform the value (inputs only)
      #
      # ## Processing Flow
      #
      # 1. **Type check**: Verify attribute is Hash-compatible
      # 2. **Schema validation**: Recursively check all nested keys and types
      # 3. **Default application**: Apply defaults to missing optional fields
      # 4. **Preparation**: Execute prepare callbacks (inputs only)
      #
      # ## Important Notes
      #
      # - Empty values for optional attributes skip validation
      # - Nested Hash types are validated recursively
      # - The `prepare` option is stripped for internals and outputs
      # - Reserved options: :type, :required, :default, :payload
      class Schema < Must # rubocop:disable Metrics/ClassLength
        # Reserved keys that are not treated as nested schema definitions.
        RESERVED_OPTIONS = %i[type required default payload].freeze
        private_constant :RESERVED_OPTIONS

        # Creates a Schema validator instance.
        #
        # @param option_name [Symbol] The option name (default: :schema)
        # @param default_hash_mode_class_names [Array<Class>] Valid Hash-like types
        # @return [Servactory::Maintenance::Attributes::OptionHelper]
        def self.use(option_name = :schema, default_hash_mode_class_names:)
          instance = new(option_name, :is, false)
          instance.assign(default_hash_mode_class_names)
          instance.must(:schema)
        end

        # Assigns the list of valid Hash-compatible class names.
        #
        # @param default_hash_mode_class_names [Array<Class>] Hash-like types to accept
        # @return [void]
        def assign(default_hash_mode_class_names)
          @default_hash_mode_class_names = default_hash_mode_class_names
        end

        # Validates schema condition for input attribute.
        #
        # @param input [Object] Input attribute object
        # @param value [Object] Hash value to validate
        # @param option [WorkOption] Schema configuration
        # @return [Boolean, Array] true if valid, or [false, reason, meta]
        def condition_for_input_with(input:, value:, option:)
          common_condition_with(attribute: input, value:, option:)
        end

        # Validates schema condition for internal attribute.
        #
        # @param internal [Object] Internal attribute object
        # @param value [Object] Hash value to validate
        # @param option [WorkOption] Schema configuration
        # @return [Boolean, Array] true if valid, or [false, reason, meta]
        def condition_for_internal_with(internal:, value:, option:)
          common_condition_with(attribute: internal, value:, option:)
        end

        # Validates schema condition for output attribute.
        #
        # @param output [Object] Output attribute object
        # @param value [Object] Hash value to validate
        # @param option [WorkOption] Schema configuration
        # @return [Boolean, Array] true if valid, or [false, reason, meta]
        def condition_for_output_with(output:, value:, option:)
          common_condition_with(attribute: output, value:, option:)
        end

        # Common validation logic for all attribute types.
        #
        # @param attribute [Object] The attribute being validated
        # @param value [Object] Hash value to validate
        # @param option [WorkOption] Schema configuration
        # @return [Boolean, Array] true if valid, or [false, reason, meta]
        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def common_condition_with(attribute:, value:, option:)
          # Schema disabled, skip validation.
          return true if option.value == false

          # Attribute type must be Hash-compatible.
          return [false, :wrong_type] unless @default_hash_mode_class_names.intersect?(attribute.types)

          # Skip validation for blank optional values.
          if value.blank? && ((attribute.input? && attribute.optional?) || attribute.internal? || attribute.output?)
            return true
          end

          schema = option.value.fetch(:is, option.value)

          # Remove :prepare option for internals and outputs.
          if attribute.internal? || attribute.output?
            schema = schema.transform_values { |options| options.except(:prepare) }
          end

          is_success, reason, meta = validate_for!(object: value, schema:)

          # Apply defaults and preparations if validation passed.
          prepare_object_with!(object: value, schema:) if is_success

          [is_success, reason, meta]
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        # Recursively validates object against schema definition.
        #
        # @param object [Hash] The object to validate
        # @param schema [Hash] Schema definition
        # @param root_schema_key [Symbol, nil] Parent key for nested validation
        # @return [Boolean, Array] true if valid, or [false, reason, meta]
        def validate_for!(object:, schema:, root_schema_key: nil) # rubocop:disable Metrics/MethodLength
          # Object must be Hash-like (respond to :fetch).
          unless object.respond_to?(:fetch)
            return [
              false,
              :wrong_element_value,
              {
                key_name: root_schema_key,
                expected_type: Hash.name,
                given_type: object.class.name
              }
            ]
          end

          # Validate each schema field.
          errors = schema.map do |schema_key, schema_value|
            attribute_type = schema_value.fetch(:type, String)

            if attribute_type == Hash
              # Recursively validate nested Hash.
              validate_for!(
                object: object.fetch(schema_key, {}),
                schema: schema_value.except(*RESERVED_OPTIONS),
                root_schema_key: schema_key
              )
            else
              is_success, given_type = validate_with(
                object:,
                schema_key:,
                schema_value:,
                attribute_type:,
                attribute_required: schema_value.fetch(:required, true)
              )

              next if is_success

              [false, :wrong_element_type, { key_name: schema_key, expected_type: attribute_type, given_type: }]
            end
          end

          # Return first error or true.
          errors.compact.first || true
        end

        # Validates a single field against its type specification.
        #
        # @param object [Hash] Parent object containing the field
        # @param schema_key [Symbol] Field key to validate
        # @param schema_value [Hash] Field schema definition
        # @param attribute_type [Class, Array<Class>] Expected type(s)
        # @param attribute_required [Boolean] Whether field is required
        # @return [Array<Boolean, String>] [success, given_type_name]
        def validate_with(object:, schema_key:, schema_value:, attribute_type:, attribute_required:) # rubocop:disable Metrics/MethodLength
          # Skip validation if not required and no value present.
          unless should_be_checked_for?(
            object:,
            schema_key:,
            schema_value:,
            required: attribute_required
          ) # do
            return true
          end

          value = object.fetch(schema_key, nil)
          prepared_value = prepare_value_from(schema_value:, value:, required: attribute_required)

          [
            Array(attribute_type).uniq.any? { |type| prepared_value.is_a?(type) },
            prepared_value.class.name
          ]
        end

        # Determines if a field should be validated.
        #
        # @param object [Hash] Parent object
        # @param schema_key [Symbol] Field key
        # @param schema_value [Hash] Field schema
        # @param required [Boolean] Whether required
        # @return [Boolean] true if validation needed
        def should_be_checked_for?(object:, schema_key:, schema_value:, required:)
          required || (
            !required && !fetch_default_from(schema_value).nil?
          ) || (
            !required && !object.fetch(schema_key, nil).nil?
          )
        end

        # Prepares value for validation, applying defaults if needed.
        #
        # @param schema_value [Hash] Field schema
        # @param value [Object] Current value
        # @param required [Boolean] Whether required
        # @return [Object] Value to validate
        def prepare_value_from(schema_value:, value:, required:)
          if !required && !fetch_default_from(schema_value).nil? && value.blank?
            fetch_default_from(schema_value)
          else
            value
          end
        end

        # Extracts default value from schema definition.
        #
        # @param value [Hash] Schema definition
        # @return [Object, nil] Default value or nil
        def fetch_default_from(value)
          value.fetch(:default, nil)
        end

        ########################################################################

        # Applies defaults and preparations to the validated object.
        #
        # @param object [Hash] Object to modify
        # @param schema [Hash] Schema definition
        # @return [void]
        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def prepare_object_with!(object:, schema:)
          schema.map do |schema_key, schema_value|
            attribute_type = schema_value.fetch(:type, String)
            required = schema_value.fetch(:required, true)
            object_value = object[schema_key]

            if attribute_type == Hash
              # Apply nested Hash defaults.
              default_value = schema_value.fetch(:default, {})

              if !required && !default_value.nil? && !Servactory::Utils.value_present?(object_value)
                object[schema_key] = default_value
              end

              # Recursively prepare nested objects.
              prepare_object_with!(
                object: object.fetch(schema_key, {}),
                schema: schema_value.except(*RESERVED_OPTIONS)
              )
            else
              # Apply scalar defaults.
              default_value = schema_value.fetch(:default, nil)

              if !required && !default_value.nil? && !Servactory::Utils.value_present?(object_value)
                object[schema_key] = default_value
              end

              # Execute prepare callback if defined.
              unless (input_prepare = schema_value.fetch(:prepare, nil)).nil?
                object[schema_key] = input_prepare.call(value: object[schema_key])
              end

              object
            end
          end
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        ########################################################################
        ########################################################################
        ########################################################################

        # Generates error message for input validation failure.
        #
        # @param service [Object] Service context
        # @param input [Object] Input attribute
        # @param reason [Symbol] Failure reason
        # @param meta [Hash] Additional metadata
        # @return [String] Localized error message
        def message_for_input_with(service:, input:, reason:, meta:, **)
          i18n_key = "inputs.validations.must.dynamic_options.schema"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            service_class_name: service.class_name,
            input_name: input.name,
            key_name: meta.fetch(:key_name),
            expected_type: meta.fetch(:expected_type),
            given_type: meta.fetch(:given_type)
          )
        end

        # Generates error message for internal validation failure.
        #
        # @param service [Object] Service context
        # @param internal [Object] Internal attribute
        # @param reason [Symbol] Failure reason
        # @param meta [Hash] Additional metadata
        # @return [String] Localized error message
        def message_for_internal_with(service:, internal:, reason:, meta:, **)
          i18n_key = "internals.validations.must.dynamic_options.schema"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            service_class_name: service.class_name,
            internal_name: internal.name,
            key_name: meta.fetch(:key_name),
            expected_type: meta.fetch(:expected_type),
            given_type: meta.fetch(:given_type)
          )
        end

        # Generates error message for output validation failure.
        #
        # @param service [Object] Service context
        # @param output [Object] Output attribute
        # @param reason [Symbol] Failure reason
        # @param meta [Hash] Additional metadata
        # @return [String] Localized error message
        def message_for_output_with(service:, output:, reason:, meta:, **)
          i18n_key = "outputs.validations.must.dynamic_options.schema"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            service_class_name: service.class_name,
            output_name: output.name,
            key_name: meta.fetch(:key_name),
            expected_type: meta.fetch(:expected_type),
            given_type: meta.fetch(:given_type)
          )
        end
      end
    end
  end
end
