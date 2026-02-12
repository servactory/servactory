# frozen_string_literal: true

module Servactory
  module Inputs
    module Tools
      module Validation
        extend self

        def validate!(context, collection_of_inputs) # rubocop:disable Metrics/MethodLength
          warehouse = context.send(:servactory_service_warehouse)
          first_error = nil
          failed_input = nil

          collection_of_inputs.each do |input|
            first_error = process_input(context, warehouse, input)
            if first_error.present?
              failed_input = input
              break
            end
          end

          return if first_error.nil?

          context.fail_input!(failed_input.name, message: first_error)
        end

        private

        def process_input(context, warehouse, input)
          value = warehouse.fetch_input(input.name)

          input.options_for_checks.each do |check_key, check_options|
            error = process_option(context, input, value, check_key, check_options)
            return error if error.present?
          end

          nil
        end

        def process_option(context, input, value, check_key, check_options) # rubocop:disable Metrics/MethodLength
          validation_classes = input.collection_of_options.validation_classes
          return if validation_classes.empty?

          validation_classes.each do |validation_class|
            error_message = validation_class.check(
              context:,
              attribute: input,
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
