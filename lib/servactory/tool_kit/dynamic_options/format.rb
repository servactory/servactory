# frozen_string_literal: true

module Servactory
  module ToolKit
    module DynamicOptions
      class Format < Must # rubocop:disable Metrics/ClassLength
        DEFAULT_FORMATS = {
          uuid: {
            pattern: /^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/,
            validator: ->(value:) { value.present? }
          },
          email: {
            pattern: URI::MailTo::EMAIL_REGEXP,
            validator: ->(value:) { value.present? }
          },
          password: {
            # NOTE: Pattern 4 » https://dev.to/rasaf_ibrahim/write-regex-password-validation-like-a-pro-5175
            #       Password must contain one digit from 1 to 9, one lowercase letter, one
            #       uppercase letter, and one underscore, and it must be 8-16 characters long.
            #       Usage of any other special character and usage of space is optional.
            pattern: /^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,16}$/,
            validator: ->(value:) { value.present? }
          },
          duration: {
            pattern: nil,
            validator: lambda do |value:|
              ActiveSupport::Duration.parse(value) and return true
            rescue ActiveSupport::Duration::ISO8601Parser::ParsingError
              false
            end
          },
          date: {
            pattern: nil,
            validator: lambda do |value:|
              Date.parse(value) and return true
            rescue Date::Error
              false
            end
          },
          datetime: {
            pattern: nil,
            validator: lambda do |value:|
              DateTime.parse(value) and return true
            rescue Date::Error
              false
            end
          },
          time: {
            pattern: nil,
            validator: lambda do |value:|
              Time.zone.parse(value) and return true
            rescue ArgumentError
              false
            end
          },
          boolean: {
            pattern: /^(true|false|0|1)$/i,
            validator: ->(value:) { %w[true 1].include?(value&.downcase) }
          }
        }.freeze
        private_constant :DEFAULT_FORMATS

        def self.use(option_name = :format, formats: {})
          instance = new(option_name)
          instance.assign(formats)
          instance.must(:be_in_format)
        end

        def assign(formats = {})
          @formats = formats.is_a?(Hash) ? DEFAULT_FORMATS.merge(formats) : DEFAULT_FORMATS
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

        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def common_condition_with(value:, option:, input: nil, internal: nil, output: nil)
          option_value = option.value&.to_sym

          return [false, :unknown] unless @formats.key?(option_value)

          attribute = Utils.define_attribute_with(input:, internal:, output:)

          if value.blank? &&
             (
               (attribute.input? && attribute.optional?) ||
                 (
                   (attribute.internal? || attribute.output?) &&
                     attribute.types.include?(NilClass)
                 )
             )
            return true
          end

          format_options = @formats.fetch(option_value)

          format_pattern = option.properties.fetch(:pattern, format_options.fetch(:pattern))

          return [false, :wrong_pattern] if format_pattern.present? && !value.match?(Regexp.compile(format_pattern))

          option.properties.fetch(:validator, format_options.fetch(:validator)).call(value:)
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        ########################################################################

        def message_for_input_with(service:, input:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "inputs.validations.must.dynamic_options.format"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            input_name: input.name,
            value:,
            option_name:,
            format_name: option_value.presence || option_value.inspect
          )
        end

        def message_for_internal_with(service:, internal:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "internals.validations.must.dynamic_options.format"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            internal_name: internal.name,
            value:,
            option_name:,
            format_name: option_value.presence || option_value.inspect
          )
        end

        def message_for_output_with(service:, output:, value:, option_name:, option_value:, reason:, **)
          i18n_key = "outputs.validations.must.dynamic_options.format"
          i18n_key += reason.present? ? ".#{reason}" : ".default"

          service.translate(
            i18n_key,
            output_name: output.name,
            value:,
            option_name:,
            format_name: option_value.presence || option_value.inspect
          )
        end
      end
    end
  end
end
