# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Inclusion < Must
        def self.use(option_name = :inclusion)
          new(option_name).must(:be_inclusion)
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
          # return true if option.value == false

          attribute = Utils.define_attribute_with(input:, internal:, output:)

          return true unless should_be_checked_for?(attribute:, value:)

          inclusion_in = fetch_inclusion_value_from(option.value)
          return true if inclusion_in.nil?

          inclusion_in.include?(value)
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

        def fetch_inclusion_value_from(option_value)
          return option_value.fetch(:in, nil) if option_value.is_a?(Hash)

          option_value
        end

        ########################################################################

        def message_for_input_with(service:, input:, value:, option_name:, option_value:, **)
          inclusion_in = fetch_inclusion_value_from(option_value)

          service.translate(
            "inputs.validations.must.dynamic_options.inclusion.default",
            input_name: input.name,
            value:,
            input_inclusion: inclusion_in
          )
        end

        def message_for_internal_with(service:, internal:, value:, option_name:, option_value:, **)
          inclusion_in = fetch_inclusion_value_from(option_value)

          service.translate(
            "internals.validations.must.dynamic_options.inclusion.default",
            internal_name: internal.name,
            value:,
            internal_inclusion: inclusion_in
          )
        end

        def message_for_output_with(service:, output:, value:, option_name:, option_value:, **)
          inclusion_in = fetch_inclusion_value_from(option_value)

          service.translate(
            "outputs.validations.must.dynamic_options.inclusion.default",
            output_name: output.name,
            value:,
            output_inclusion: inclusion_in
          )
        end
      end
    end
  end
end
