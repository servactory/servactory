# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Inclusion < Must
        def self.use(option_name = :inclusion)
          instance = new(option_name, :in, nil)
          instance.must(:consists_of)
        end

        def condition_for_input_with(...)
          common_condition_with(...)
        end

        def condition_for_internal_with(...)
          common_condition_with(...)
        end

        def condition_for_output_with(...)
          common_condition_with(...)
        end

        def common_condition_with(value:, option:, input: nil, internal: nil, output: nil)
          attribute = Utils.define_attribute_with(input:, internal:, output:)

          return true unless should_be_checked_for?(attribute:, value:)

          option.value.include?(value)
        end

        ########################################################################

        def should_be_checked_for?(attribute:, value:) # rubocop:disable Metrics/CyclomaticComplexity
          (
            attribute.input? && (
              attribute.required? || (
                attribute.optional? && !attribute.default.nil?
              ) || (
                attribute.optional? && !value.nil?
              )
            )
          ) || attribute.internal? || attribute.output?
        end

        ########################################################################

        def message_for_input_with(service:, input:, value:, option_value:, **)
          service.translate(
            "inputs.validations.must.dynamic_options.inclusion.default",
            input_name: input.name,
            value:,
            input_inclusion: option_value
          )
        end

        def message_for_internal_with(service:, internal:, value:, option_value:, **)
          service.translate(
            "internals.validations.must.dynamic_options.inclusion.default",
            internal_name: internal.name,
            value:,
            internal_inclusion: option_value
          )
        end

        def message_for_output_with(service:, output:, value:, option_value:, **)
          service.translate(
            "outputs.validations.must.dynamic_options.inclusion.default",
            output_name: output.name,
            value:,
            output_inclusion: option_value
          )
        end
      end
    end
  end
end
