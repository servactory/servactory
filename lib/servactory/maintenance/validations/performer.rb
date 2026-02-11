# frozen_string_literal: true

module Servactory
  module Maintenance
    module Validations
      module Performer
        extend self

        def validate!(context:, attribute:, value:)
          first_error = process(context:, attribute:, value:)
          return if first_error.nil?

          context.public_send(
            :"fail_#{attribute.system_name}!",
            attribute.name,
            message: first_error
          )
        end

        private

        def process(context:, attribute:, value:)
          attribute.options_for_checks.each do |check_key, check_options|
            error = process_option(
              context:,
              attribute:,
              value:,
              check_key:,
              check_options:
            )
            return error if error.present?
          end

          nil
        end

        def process_option(context:, attribute:, value:, check_key:, check_options:)
          validation_classes = attribute.collection_of_options.validation_classes
          return if validation_classes.empty?

          validation_classes.each do |validation_class|
            error_message = validation_class.check(
              context:,
              attribute:,
              value:,
              check_key:,
              check_options:
            )
            return error_message if error_message.present?
          end

          nil
        end
      end
    end
  end
end
