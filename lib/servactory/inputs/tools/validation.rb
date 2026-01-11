# frozen_string_literal: true

module Servactory
  module Inputs
    module Tools
      class Validation
        def self.validate!(...)
          new(...).validate!
        end

        def initialize(context, collection_of_inputs)
          @context = context
          @collection_of_inputs = collection_of_inputs
          @first_error = nil
        end

        def validate!
          @collection_of_inputs.each do |input|
            process_input(input)
            break if @first_error.present?
          end

          raise_errors
        end

        private

        def process_input(input)
          input.options_for_checks.each do |check_key, check_options|
            process_option(check_key, check_options, input:)
            break if @first_error.present?
          end
        end

        def process_option(check_key, check_options, input:) # rubocop:disable Metrics/MethodLength
          validation_classes = validation_classes_from(input)
          return if validation_classes.empty?

          validation_classes.each do |validation_class|
            error_message = process_validation_class(
              validation_class:,
              input:,
              check_key:,
              check_options:
            )

            next if error_message.blank?

            @first_error = error_message
            break
          end
        end

        def process_validation_class(
          validation_class:,
          input:,
          check_key:,
          check_options:
        )
          validation_class.check(
            context: @context,
            attribute: input,
            value: @context.send(:servactory_service_warehouse).fetch_input(input.name),
            check_key:,
            check_options:
          )
        end

        ########################################################################

        def validation_classes_from(input)
          @validation_classes_cache ||= input.collection_of_options.validation_classes # rubocop:disable Naming/MemoizedInstanceVariableName
        end

        ########################################################################

        def raise_errors
          return if @first_error.nil?

          @context.fail_input!(nil, message: @first_error)
        end
      end
    end
  end
end
