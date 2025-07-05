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
        end

        def validate!
          @collection_of_inputs.each do |input|
            process_input(input)
          end

          raise_errors
        end

        private

        def process_input(input)
          input.options_for_checks.each do |check_key, check_options|
            process_option(check_key, check_options, input:)
          end
        end

        def process_option(check_key, check_options, input:) # rubocop:disable Metrics/MethodLength
          validation_classes = validation_classes_from(input)
          return if validation_classes.empty?

          validation_classes.each do |validation_class|
            errors_from_checks = process_validation_class(
              validation_class:,
              input:,
              check_key:,
              check_options:
            )

            next if errors_from_checks.nil? || errors_from_checks.empty?

            errors.merge(errors_from_checks.to_a)
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

        def errors
          @errors ||= Servactory::Maintenance::Attributes::Tools::CheckErrors.new
        end

        def raise_errors
          return if (tmp_errors = errors.not_blank).empty?

          @context.fail_input!(nil, message: tmp_errors.first)
        end
      end
    end
  end
end
