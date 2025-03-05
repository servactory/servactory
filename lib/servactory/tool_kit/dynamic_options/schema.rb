# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Schema < Must # rubocop:disable Metrics/ClassLength
        RESERVED_OPTIONS = %i[type required default payload].freeze
        private_constant :RESERVED_OPTIONS

        def self.use(option_name = :schema, default_hash_mode_class_names:)
          instance = new(option_name, :is, false)
          instance.assign(default_hash_mode_class_names)
          instance.must(:schema)
        end

        def assign(default_hash_mode_class_names)
          @default_hash_mode_class_names = default_hash_mode_class_names
        end

        def condition_for_input_with(input:, value:, option:)
          common_condition_with(attribute: input, value:, option:)
        end

        def condition_for_internal_with(internal:, value:, option:)
          common_condition_with(attribute: internal, value:, option:)
        end

        def condition_for_output_with(output:, value:, option:)
          common_condition_with(attribute: output, value:, option:)
        end

        def common_condition_with(attribute:, value:, option:) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          return true if option.value == false
          return [false, :wrong_type] if @default_hash_mode_class_names.intersection(attribute.types).empty?

          if value.blank? && ((attribute.input? && attribute.optional?) || attribute.internal? || attribute.output?)
            return true
          end

          schema = option.value.fetch(:is, option.value)

          is_success, reason, meta = validate_for!(object: value, schema:)

          prepare_object_with!(object: value, schema:) if is_success

          [is_success, reason, meta]
        end

        def validate_for!(object:, schema:, root_schema_key: nil) # rubocop:disable Metrics/MethodLength
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

          errors = schema.map do |schema_key, schema_value|
            attribute_type = schema_value.fetch(:type, String)

            if attribute_type == Hash
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

          errors.compact.first || true
        end

        def validate_with(object:, schema_key:, schema_value:, attribute_type:, attribute_required:) # rubocop:disable Metrics/MethodLength
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

        def should_be_checked_for?(object:, schema_key:, schema_value:, required:)
          required || (
            !required && !fetch_default_from(schema_value).nil?
          ) || (
            !required && !object.fetch(schema_key, nil).nil?
          )
        end

        def prepare_value_from(schema_value:, value:, required:)
          if !required && !fetch_default_from(schema_value).nil? && value.blank?
            fetch_default_from(schema_value)
          else
            value
          end
        end

        def fetch_default_from(value)
          value.fetch(:default, nil)
        end

        ########################################################################

        def prepare_object_with!(object:, schema:) # rubocop:disable Metrics/MethodLength
          schema.map do |schema_key, schema_value|
            attribute_type = schema_value.fetch(:type, String)

            if attribute_type == Hash
              prepare_object_with!(
                object: object.fetch(schema_key, {}),
                schema: schema_value.except(*RESERVED_OPTIONS)
              )
            else
              unless (default = schema_value.fetch(:default, nil)).nil?
                object[schema_key] = default
              end

              unless (input_prepare = schema_value.fetch(:prepare, nil)).nil?
                object[schema_key] = input_prepare.call(value: object[schema_key])
              end

              object
            end
          end
        end

        ########################################################################
        ########################################################################
        ########################################################################

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
