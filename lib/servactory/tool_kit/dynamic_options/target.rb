# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Target < Must
        def self.use(option_name = :target)
          instance = new(option_name, :in)
          instance.must(:"be_#{option_name}")
        end

        def condition_for_input_with(input:, value:, option:) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
          return [false, :invalid_option] if option.value.nil?

          target_values = normalize_target_values(option.value, input.types)

          return target_values.include?(value) if input.required? || (input.optional? && !value.nil?)

          return target_values.include?(input.default) if input.optional? && value.nil? && !input.default.nil?

          true
        end

        def condition_for_internal_with(value:, option:, internal: nil, **)
          return [false, :invalid_option] if option.value.nil?

          target_values = normalize_target_values(option.value, internal.types)

          target_values.include?(value)
        end

        def condition_for_output_with(value:, option:, output: nil, **)
          return [false, :invalid_option] if option.value.nil?

          target_values = normalize_target_values(option.value, output.types)

          target_values.include?(value)
        end

        ########################################################################

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

        def normalize_target_values(option_value, types)
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
