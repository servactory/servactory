# frozen_string_literal: true

module Servactory
  module Outputs
    module Tools
      class Validation
        def self.validate!(...)
          new(...).validate!
        end

        def initialize(context:, output:, value:)
          @context = context
          @output = output
          @value = value
        end

        def validate!
          process

          raise_errors
        end

        private

        def process
          @output.options_for_checks.each do |check_key, check_options|
            process_option(check_key, check_options)
          end
        end

        def process_option(check_key, check_options)
          validation_classes.each do |validation_class|
            errors_from_checks = process_validation_class(
              validation_class: validation_class,
              check_key: check_key,
              check_options: check_options
            )

            errors.merge(errors_from_checks.to_a)
          end
        end

        def process_validation_class(
          validation_class:,
          check_key:,
          check_options:
        )
          validation_class.check(
            context: @context,
            input: @output,
            value: @value,
            check_key: check_key,
            check_options: check_options
          )
        end

        ########################################################################

        def validation_classes
          @output.collection_of_options.validation_classes
        end

        ########################################################################

        def errors
          @errors ||= CheckErrors.new
        end

        def raise_errors
          return if (tmp_errors = errors.not_blank).empty?

          raise @context.class.config.output_error_class.new(message: tmp_errors.first)
        end
      end
    end
  end
end
