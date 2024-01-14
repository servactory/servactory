# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Validations
        class Must < Base
          DEFAULT_MESSAGE = lambda do |service_class_name:, value:, code:, input: nil, internal: nil, output: nil|
            attribute = Servactory::Utils.define_attribute_with(input: input, internal: internal, output: output)

            I18n.t(
              "servactory.#{attribute.i18n_name}.validations.must.default_error",
              service_class_name: service_class_name,
              "#{attribute.system_name}_name": attribute.name,
              value: value,
              code: code
            )
          end

          SYNTAX_ERROR_MESSAGE = lambda do
            |service_class_name:, value:, code:, exception_message:, input: nil, internal: nil, output: nil|
            attribute = Servactory::Utils.define_attribute_with(input: input, internal: internal, output: output)

            I18n.t(
              "servactory.#{attribute.i18n_name}.validations.must.syntax_error",
              service_class_name: service_class_name,
              "#{attribute.system_name}_name": attribute.name,
              value: value,
              code: code,
              exception_message: exception_message
            )
          end

          private_constant :DEFAULT_MESSAGE, :SYNTAX_ERROR_MESSAGE

          def self.check(context:, attribute:, value:, check_key:, check_options:)
            return unless should_be_checked_for?(attribute, check_key)

            new(context: context, attribute: attribute, value: value, check_options: check_options).check
          end

          def self.should_be_checked_for?(attribute, check_key)
            check_key == :must && attribute.must_present?
          end

          ##########################################################################

          def initialize(context:, attribute:, value:, check_options:)
            super()

            @context = context
            @attribute = attribute
            @value = value
            @check_options = check_options
          end

          def check
            @check_options.each do |code, options|
              message = call_or_fetch_message_from(code, options)

              next if message.blank?

              add_error_with(message, code)
            end

            errors
          end

          private

          def call_or_fetch_message_from(code, options)
            check, message = options.values_at(:is, :message)

            return if check.call(value: @value)

            message.presence || DEFAULT_MESSAGE
          rescue StandardError => e
            add_syntax_error_with(SYNTAX_ERROR_MESSAGE, code, e.message)
          end

          ########################################################################

          def add_error_with(message, code)
            add_error(
              message: message,
              service_class_name: @context.class.name,
              "#{@attribute.system_name}": @attribute,
              value: @value,
              code: code
            )
          end

          def add_syntax_error_with(message, code, exception_message)
            add_error(
              message: message,
              service_class_name: @context.class.name,
              "#{@attribute.system_name}": @attribute,
              value: @value,
              code: code,
              exception_message: exception_message
            )
          end
        end
      end
    end
  end
end
