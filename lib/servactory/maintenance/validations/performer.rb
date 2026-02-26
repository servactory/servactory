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
          attribute.collection_of_options.validations_for_checks.each do |check_key, check_options, validation_class|
            error = process_option(
              context:, attribute:, value:,
              check_key:, check_options:, validation_class:
            )
            return error if error.present?
          end

          nil
        end

        def process_option(context:, attribute:, value:, check_key:, check_options:, validation_class:)
          validation_class.check(
            context:,
            attribute:,
            value:,
            check_key:,
            check_options:
          )
        end
      end
    end
  end
end
