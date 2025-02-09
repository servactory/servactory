# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Inclusion < Must
        def self.use(option_name = :inclusion)
          instance = new(option_name, :in)
          instance.must(:consists_of)
        end

        def condition_for_input_with(input:, value:, option:)
          if input.required? || (
            input.optional? && !input.default.nil?
          ) || (
            input.optional? && !value.nil?
          ) # do
            return option.value.include?(value)
          end

          true
        end

        def condition_for_internal_with(value:, option:, **)
          option.value.include?(value)
        end

        def condition_for_output_with(value:, option:, **)
          option.value.include?(value)
        end

        ########################################################################

        def message_for_input_with(service:, input:, value:, option_value:, **)
          service.translate(
            "inputs.validations.must.dynamic_options.inclusion.default",
            input_name: input.name,
            value: value.inspect,
            input_inclusion: option_value.inspect
          )
        end

        def message_for_internal_with(service:, internal:, value:, option_value:, **)
          service.translate(
            "internals.validations.must.dynamic_options.inclusion.default",
            internal_name: internal.name,
            value: value.inspect,
            internal_inclusion: option_value.inspect
          )
        end

        def message_for_output_with(service:, output:, value:, option_value:, **)
          service.translate(
            "outputs.validations.must.dynamic_options.inclusion.default",
            output_name: output.name,
            value: value.inspect,
            output_inclusion: option_value.inspect
          )
        end
      end
    end
  end
end
