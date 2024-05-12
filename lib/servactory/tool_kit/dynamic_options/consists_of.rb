# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class ConsistsOf < Must
        def self.use(option_name = :consists_of, collection_mode_class_names:)
          instance = new(option_name, :type, false)
          instance.assign(collection_mode_class_names)
          instance.must(:consists_of)
        end

        def assign(collection_mode_class_names)
          @collection_mode_class_names = collection_mode_class_names
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

        def common_condition_with(attribute:, value:, option:)
          return true if option.value == false
          return [false, :wrong_type] if @collection_mode_class_names.intersection(attribute.types).empty?

          values = value.respond_to?(:flatten) ? value&.flatten : value

          validate_for!(attribute:, values:, option:)
        end

        def validate_for!(attribute:, values:, option:)
          consists_of_types = Array(option.value)

          return [false, :required] if fails_presence_validation?(attribute:, values:, consists_of_types:)

          return true if values.blank? && attribute.input? && attribute.optional?

          return true if values.all? do |value|
            consists_of_types.include?(value.class)
          end

          [false, :wrong_element_type]
        end

        def fails_presence_validation?(attribute:, values:, consists_of_types:)
          return false if consists_of_types.include?(NilClass)

          check_present = proc { _1 && !values.all?(&:present?) }

          [
            check_present[attribute.input? && (attribute.required? || (attribute.optional? && values.present?))],
            check_present[attribute.internal?],
            check_present[attribute.output?]
          ].any?
        end

        ########################################################################

        def message_for_input_with(service:, input:, value:, option_value:, reason:, **)
          i18n_key = "servactory.inputs.validations.must.dynamic_options.consists_of"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          I18n.t(
            i18n_key,
            service_class_name: service.class_name,
            input_name: input.name,
            expected_type: Array(option_value).uniq.join(", "),
            given_type: given_type_for(values: value, option_value:)
          )
        end

        def message_for_internal_with(service:, internal:, value:, option_value:, reason:, **)
          i18n_key = "servactory.internals.validations.must.dynamic_options.consists_of"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          I18n.t(
            i18n_key,
            service_class_name: service.class_name,
            internal_name: internal.name,
            expected_type: Array(option_value).uniq.join(", "),
            given_type: given_type_for(values: value, option_value:)
          )
        end

        def message_for_output_with(service:, output:, value:, option_value:, reason:, **)
          i18n_key = "servactory.outputs.validations.must.dynamic_options.consists_of"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          I18n.t(
            i18n_key,
            service_class_name: service.class_name,
            output_name: output.name,
            expected_type: Array(option_value).uniq.join(", "),
            given_type: given_type_for(values: value, option_value:)
          )
        end

        def given_type_for(values:, option_value:)
          return "NilClass" if values.nil?

          values = values&.flatten if values.respond_to?(:flatten)

          values.filter { |value| Array(option_value).exclude?(value.class) }.map(&:class).uniq.join(", ")
        end
      end
    end
  end
end
