# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Format < Must
        FORMATS = {
          email: {
            pattern: URI::MailTo::EMAIL_REGEXP,
            validator: ->(value:) { value.present? }
          },
          date: {
            pattern: /^([0-9]{4})-?(1[0-2]|0[1-9])-?(3[01]|0[1-9]|[12][0-9])$/,
            validator: lambda do |value:|
              Date.parse(value) and return true
            rescue Date::Error
              false
            end
          }
        }.freeze
        private_constant :FORMATS

        def self.setup(option_name = :format)
          new(option_name).must(:be_in_format)
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
          option_value = option.value&.to_sym

          return [false, :unknown] unless FORMATS.key?(option_value)

          format_options = FORMATS.fetch(option_value)

          format_pattern = option.properties.fetch(:pattern, format_options.fetch(:pattern))

          return [false, :wrong_pattern] if format_pattern.present? && !value.match?(Regexp.compile(format_pattern))

          option.properties.fetch(:validator, format_options.fetch(:validator)).call(value: value)
        end

        ########################################################################

        def message_for_input_with(service_class_name:, input:, value:, option_value:, reason:, **)
          i18n_key = "servactory.inputs.validations.must.dynamic_options.format"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          I18n.t(
            i18n_key,
            service_class_name: service_class_name,
            input_name: input.name,
            value: value,
            format_name: option_value.present? ? option_value : option_value.inspect
          )
        end

        def message_for_internal_with(service_class_name:, internal:, value:, option_value:, reason:, **)
          i18n_key = "servactory.internals.validations.must.dynamic_options.format"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          I18n.t(
            i18n_key,
            service_class_name: service_class_name,
            internal_name: internal.name,
            value: value,
            format_name: option_value.present? ? option_value : option_value.inspect
          )
        end

        def message_for_output_with(service_class_name:, output:, value:, option_value:, reason:, **)
          i18n_key = "servactory.outputs.validations.must.dynamic_options.format"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          I18n.t(
            i18n_key,
            service_class_name: service_class_name,
            output_name: output.name,
            value: value,
            format_name: option_value.present? ? option_value : option_value.inspect
          )
        end
      end
    end
  end
end
