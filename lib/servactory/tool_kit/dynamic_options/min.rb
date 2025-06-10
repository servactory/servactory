# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Min < Must
        def self.use(option_name = :min)
          new(option_name).must(:be_greater_than_or_equal_to)
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

        def common_condition_with(value:, option:, **) # rubocop:disable Naming/PredicateMethod
          case value
          when Integer
            value >= option.value
          else
            return false unless value.respond_to?(:size)

            value.size >= option.value
          end
        end

        ########################################################################

        def message_for_input_with(service:, input:, value:, option_name:, option_value:, **)
          service.translate(
            "inputs.validations.must.dynamic_options.min.default",
            input_name: input.name,
            value:,
            option_name:,
            option_value:
          )
        end

        def message_for_internal_with(service:, internal:, value:, option_name:, option_value:, **)
          service.translate(
            "internals.validations.must.dynamic_options.min.default",
            internal_name: internal.name,
            value:,
            option_name:,
            option_value:
          )
        end

        def message_for_output_with(service:, output:, value:, option_name:, option_value:, **)
          service.translate(
            "outputs.validations.must.dynamic_options.min.default",
            output_name: output.name,
            value:,
            option_name:,
            option_value:
          )
        end
      end
    end
  end
end
