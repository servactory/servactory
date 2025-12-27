# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class MultipleOf < Must
        def self.use(option_name = :multiple_of)
          new(option_name).must(:"be_#{option_name}")
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
          when Integer, Float, Rational, BigDecimal
            return false if option.value.blank?
            return false unless option.value.is_a?(Numeric)
            return false if option.value.zero?

            remainder = value % option.value
            remainder.zero? || remainder.abs < Float::EPSILON * [value.abs, option.value.abs].max
          else
            false
          end
        end

        ########################################################################

        def message_for_input_with(service:, input:, value:, option_name:, option_value:, **) # rubocop:disable Metrics/MethodLength
          i18n_key = "inputs.validations.must.dynamic_options.multiple_of"

          i18n_key += if option_value.blank?
                        ".blank"
                      elsif option_value.is_a?(Numeric) && option_value.zero?
                        ".divided_by_0"
                      else
                        ".default"
                      end

          service.translate(
            i18n_key,
            input_name: input.name,
            value:,
            option_name:,
            option_value: option_value.inspect
          )
        end

        def message_for_internal_with(service:, internal:, value:, option_name:, option_value:, **) # rubocop:disable Metrics/MethodLength
          i18n_key = "internals.validations.must.dynamic_options.multiple_of"

          i18n_key += if option_value.blank?
                        ".blank"
                      elsif option_value.is_a?(Numeric) && option_value.zero?
                        ".divided_by_0"
                      else
                        ".default"
                      end

          service.translate(
            i18n_key,
            internal_name: internal.name,
            value:,
            option_name:,
            option_value: option_value.inspect
          )
        end

        def message_for_output_with(service:, output:, value:, option_name:, option_value:, **) # rubocop:disable Metrics/MethodLength
          i18n_key = "outputs.validations.must.dynamic_options.multiple_of"

          i18n_key += if option_value.blank?
                        ".blank"
                      elsif option_value.is_a?(Numeric) && option_value.zero?
                        ".divided_by_0"
                      else
                        ".default"
                      end

          service.translate(
            i18n_key,
            output_name: output.name,
            value:,
            option_name:,
            option_value: option_value.inspect
          )
        end
      end
    end
  end
end
