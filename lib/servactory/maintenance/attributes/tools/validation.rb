# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Tools
        class Validation
          def self.validate!(...)
            new(...).validate!
          end

          def initialize(context:, attribute:, value:)
            @context = context
            @attribute = attribute
            @value = value
          end

          def validate!
            process

            raise_errors
          end

          private

          def process
            @attribute.options_for_checks.each do |check_key, check_options|
              process_option(check_key, check_options)
            end
          end

          def process_option(check_key, check_options)
            return if validation_classes.empty?

            validation_classes.each do |validation_class|
              errors_from_checks = process_validation_class(
                validation_class:,
                check_key:,
                check_options:
              )

              next if errors_from_checks.nil? || errors_from_checks.empty?

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
              attribute: @attribute,
              value: @value,
              check_key:,
              check_options:
            )
          end

          ######################################################################

          def validation_classes
            @validation_classes ||= @attribute.collection_of_options.validation_classes
          end

          ######################################################################

          def errors
            @errors ||= Servactory::Maintenance::Attributes::Tools::CheckErrors.new
          end

          def raise_errors
            return if (tmp_errors = errors.not_blank).empty?

            raise @context.class.config
                          .public_send(:"#{@attribute.system_name}_exception_class")
                          .new(context: @context, message: tmp_errors.first)
          end
        end
      end
    end
  end
end
