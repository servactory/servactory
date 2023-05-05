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

          @errors = []
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
            process_option(check_key, check_options, input:)
          end
        end

        def process_option(check_key, check_options, input:)
          check_classes.each do |check_class|
            errors_from_checks = process_check_class(check_class, input:, check_key:, check_options:)

            @errors.push(*errors_from_checks)
          end
        end

        def process_check_class(check_class, input:, check_key:, check_options:)
          check_class.check(
            context: @context,
            input:,
            value: @incoming_arguments.fetch(input.name, nil),
            check_key:,
            check_options:
          )
        end

        ########################################################################

        def check_classes
          [
            Servactory::InputArguments::Checks::Required,
            Servactory::InputArguments::Checks::Type,
            Servactory::InputArguments::Checks::Inclusion,
            Servactory::InputArguments::Checks::Must
          ]
        end

        ########################################################################

        def raise_errors
          return if @errors.empty?

          raise Servactory.configuration.input_argument_error_class, @errors.first
        end
      end
    end
  end
end
