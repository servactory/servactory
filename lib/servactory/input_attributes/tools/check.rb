# frozen_string_literal: true

module Servactory
  module InputArguments
    module Tools
      class Check
        def self.check!(...)
          new(...).check!
        end

        def initialize(context, incoming_arguments, collection_of_input_arguments)
          @context = context
          @incoming_arguments = incoming_arguments
          @collection_of_input_arguments = collection_of_input_arguments
        end

        def check!
          @collection_of_input_arguments.each do |input|
            process_input(input)
          end

          raise_errors
        end

        private

        def process_input(input)
          input.options_for_checks.each do |check_key, check_options|
            process_option(check_key, check_options, input: input)
          end
        end

        def process_option(check_key, check_options, input:)
          check_classes_from(input).each do |check_class|
            errors_from_checks = process_check_class(
              check_class,
              input: input,
              check_key: check_key,
              check_options: check_options
            )

            errors.merge(errors_from_checks.to_a)
          end
        end

        def process_check_class(check_class, input:, check_key:, check_options:)
          check_class.check(
            context: @context,
            input: input,
            value: @incoming_arguments.fetch(input.name, nil),
            check_key: check_key,
            check_options: check_options
          )
        end

        ########################################################################

        def check_classes_from(input)
          input.collection_of_options.check_classes
        end

        ########################################################################

        def errors
          @errors ||= CheckErrors.new
        end

        def raise_errors
          return if (tmp_errors = errors.not_blank).empty?

          raise Servactory.configuration.input_argument_error_class.new(message: tmp_errors.first)
        end
      end
    end
  end
end
