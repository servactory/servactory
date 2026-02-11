# frozen_string_literal: true

module Servactory
  module Inputs
    module Tools
      module Validation
        extend self

        def validate!(context, collection_of_inputs)
          first_error = nil

          collection_of_inputs.each do |input|
            first_error = process_input(context, input)
            break if first_error.present?
          end

          return if first_error.nil?

          context.fail_input!(nil, message: first_error)
        end

        private

        def process_input(context, input)
          input.options_for_checks.each do |check_key, check_options|
            error = process_option(context, input, check_key, check_options)
            return error if error.present?
          end
          nil
        end

        def process_option(context, input, check_key, check_options) # rubocop:disable Metrics/MethodLength
          validation_classes = input.collection_of_options.validation_classes
          return if validation_classes.empty?

          validation_classes.each do |validation_class|
            error_message = validation_class.check(
              context:,
              attribute: input,
              value: context.send(:servactory_service_warehouse).fetch_input(input.name),
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
