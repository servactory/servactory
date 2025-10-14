# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Target < Must
        def self.use(option_name = :target)
          instance = new(option_name, :in)
          instance.must(:"be_#{option_name}")
        end

        def condition_for_input_with(input:, value:, option:) # rubocop:disable Naming/PredicateMethod
          target_values = normalize_target_values(option.value, input.types)

          return target_values.include?(value) if input.required? || (input.optional? && !value.nil?)

          return target_values.include?(input.default) if input.optional? && value.nil? && !input.default.nil?

          true
        end

        def condition_for_internal_with(value:, option:, internal: nil, **) # rubocop:disable Naming/PredicateMethod
          target_values = normalize_target_values(option.value, internal.types)

          target_values.include?(value)
        end

        def condition_for_output_with(value:, option:, output: nil, **) # rubocop:disable Naming/PredicateMethod
          target_values = normalize_target_values(option.value, output.types)

          target_values.include?(value)
        end

        ########################################################################

        def message_for_input_with(service:, input:, value:, option_value:, **)
          service.translate(
            "inputs.validations.must.dynamic_options.target.default",
            input_name: input.name,
            value: value.inspect,
            expected_target: option_value.inspect
          )
        end

        def message_for_internal_with(service:, internal:, value:, option_value:, **)
          service.translate(
            "internals.validations.must.dynamic_options.target.default",
            internal_name: internal.name,
            value: value.inspect,
            expected_target: option_value.inspect
          )
        end

        def message_for_output_with(service:, output:, value:, option_value:, **)
          service.translate(
            "outputs.validations.must.dynamic_options.target.default",
            output_name: output.name,
            value: value.inspect,
            expected_target: option_value.inspect
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
