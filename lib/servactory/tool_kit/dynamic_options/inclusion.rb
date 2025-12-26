# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Inclusion < Must
        def self.use(option_name = :inclusion)
          instance = new(option_name, :in)
          instance.must(:be_inclusion)
        end

        def condition_for_input_with(input:, value:, option:) # rubocop:disable Naming/PredicateMethod
          return [false, :invalid_option] if option.value.nil?

          if input.required? || (input.optional? && !value.nil?) # rubocop:disable Style/IfUnlessModifier
            return option.value.include?(value)
          end

          if input.optional? && value.nil? && !input.default.nil? # rubocop:disable Style/IfUnlessModifier
            return option.value.include?(input.default)
          end

          true
        end

        def condition_for_internal_with(value:, option:, **) # rubocop:disable Naming/PredicateMethod
          return [false, :invalid_option] if option.value.nil?

          option.value.include?(value)
        end

        def condition_for_output_with(value:, option:, **) # rubocop:disable Naming/PredicateMethod
          return [false, :invalid_option] if option.value.nil?

          option.value.include?(value)
        end

        ########################################################################

        def message_for_input_with(service:, input:, value:, option_value:, reason:, **)
          i18n_key = "inputs.validations.must.dynamic_options.inclusion"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            input_name: input.name,
            value: value.inspect,
            input_inclusion: option_value.inspect
          )
        end

        def message_for_internal_with(service:, internal:, value:, option_value:, reason:, **)
          i18n_key = "internals.validations.must.dynamic_options.inclusion"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            internal_name: internal.name,
            value: value.inspect,
            internal_inclusion: option_value.inspect
          )
        end

        def message_for_output_with(service:, output:, value:, option_value:, reason:, **)
          i18n_key = "outputs.validations.must.dynamic_options.inclusion"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            output_name: output.name,
            value: value.inspect,
            output_inclusion: option_value.inspect
          )
        end
      end
    end
  end
end
