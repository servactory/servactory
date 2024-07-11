# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class MultipleOf < Must
        def self.use(option_name = :multiple_of)
          new(option_name).must(:be_multiple_of)
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

        def common_condition_with(value:, option:, **)
          case value
          when Integer, Float, Rational, BigDecimal
            return false if option.value.blank?
            return false unless [Numeric, Float, Rational, BigDecimal].any? { |c| option.value.is_a?(c) }
            return false if option.value.zero?

            (value % option.value).zero?
          else
            false
          end
        end

        ########################################################################

        def message_for_input_with(service:, input:, value:, option_name:, option_value:, **) # rubocop:disable Metrics/MethodLength
          i18n_key = "inputs.validations.must.dynamic_options.multiple_of"

          i18n_key += if option_value.blank?
                        ".blank"
                      elsif [Numeric, Float, Rational, BigDecimal].any? { |c| value.is_a?(c) } && value.zero?
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
                      elsif [Numeric, Float, Rational, BigDecimal].any? { |c| value.is_a?(c) } && value.zero?
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
                      elsif [Numeric, Float, Rational, BigDecimal].any? { |c| value.is_a?(c) } && value.zero?
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
