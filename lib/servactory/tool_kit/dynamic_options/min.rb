# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Min < Must
        def self.setup(option_name = :min)
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

        def common_condition_with(value:, option_value:, **)
          case value
          when Integer
            value >= option_value
          else
            return false unless value.respond_to?(:size)

            value.size >= option_value
          end
        end

        ########################################################################

        def message_for_input_with(service_class_name:, input:, value:, option_value:, **)
          "[#{service_class_name}] Input attribute `#{input.name}` " \
            "received value `#{value}`, which is less than `#{option_value}`"
        end

        def message_for_internal_with(service_class_name:, internal:, value:, option_value:, **)
          "[#{service_class_name}] Internal attribute `#{internal.name}` " \
            "received value `#{value}`, which is less than `#{option_value}`"
        end

        def message_for_output_with(service_class_name:, output:, value:, option_value:, **)
          "[#{service_class_name}] Output attribute `#{output.name}` " \
            "received value `#{value}`, which is less than `#{option_value}`"
        end
      end
    end
  end
end
