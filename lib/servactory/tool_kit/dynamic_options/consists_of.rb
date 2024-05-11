# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class ConsistsOf < Must
        COLLECTION_CLASS_NAMES = [Array, Set].freeze
        private_constant :COLLECTION_CLASS_NAMES

        def self.setup(option_name = :consists_of)
          new(option_name, :type, false).must(:consists_of)
        end

        def condition_for_input_with(input:, value:, option:)
          common_condition_with(attribute: input, value: value, option: option)
        end

        def condition_for_internal_with(internal:, value:, option:)
          common_condition_with(attribute: internal, value: value, option: option)
        end

        def condition_for_output_with(output:, value:, option:)
          common_condition_with(attribute: output, value: value, option: option)
        end

        def common_condition_with(attribute:, value:, option:)
          return true if option.value == false
          return false if COLLECTION_CLASS_NAMES.intersection(attribute.types).empty?

          validate_for!(values: value, option: option)
        end

        def validate_for!(values:, option:) # rubocop:disable Metrics/CyclomaticComplexity
          consists_of_types = Array(option.value)

          return [false, :required] if !consists_of_types.include?(NilClass) && !values&.flatten&.all?(&:present?)

          return true if values.flatten.all? do |value|
            consists_of_types.include?(value.class)
          end

          [false, :wrong_type]
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
            given_type: given_type_for(values: value, option_value: option_value)
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
            given_type: given_type_for(values: value, option_value: option_value)
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
            given_type: given_type_for(values: value, option_value: option_value)
          )
        end

        def given_type_for(values:, option_value:)
          return nil if values.nil?

          values.flatten.filter { |value| Array(option_value).exclude?(value.class) }.map(&:class).uniq.join(", ")
        end
      end
    end
  end
end
