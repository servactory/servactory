# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Validations
        class Must < Base
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
              message, reason = call_or_fetch_message_from(code, options)

              next if message.blank?

              add_error_with(message, code, reason)
            end

            errors
          end

          private

          def call_or_fetch_message_from(code, options) # rubocop:disable Metrics/MethodLength
            check, message = options.values_at(:is, :message)

            check_result, check_result_code =
              check.call(value: @value, **Servactory::Utils.fetch_hash_with_desired_attribute(@attribute))

            return if check_result

            [
              message.presence || Servactory::Maintenance::Attributes::Translator::Must.default_message,
              check_result_code
            ]
          rescue StandardError => e
            add_syntax_error_with(
              Servactory::Maintenance::Attributes::Translator::Must.syntax_error_message,
              code,
              e.message
            )
          end

          ########################################################################

          def add_error_with(message, code, reason)
            add_error(
              message: message,
              service_class_name: @context.class.name,
              **Servactory::Utils.fetch_hash_with_desired_attribute(@attribute),
              value: @value,
              code: code,
              reason: reason
            )
          end

          def add_syntax_error_with(message, code, exception_message)
            add_error(
              message: message,
              service_class_name: @context.class.name,
              **Servactory::Utils.fetch_hash_with_desired_attribute(@attribute),
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
