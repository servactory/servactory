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
            @first_error = nil
          end

          def validate!
            process

            raise_errors
          end

          private

          def process
            @attribute.options_for_checks.each do |check_key, check_options|
              process_option(check_key, check_options)
              break if @first_error
            end
          end

          def process_option(check_key, check_options)
            return if validation_classes.empty?

            validation_classes.each do |validation_class|
              error_message = process_validation_class(
                validation_class:,
                check_key:,
                check_options:
              )

              next if error_message.nil?

              @first_error ||= error_message
              break
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

          ########################################################################

          def validation_classes
            @validation_classes ||= @attribute.collection_of_options.validation_classes
          end

          ########################################################################

          def raise_errors
            return if @first_error.nil?

            raise @context.config
                          .public_send(:"#{@attribute.system_name}_exception_class")
                          .new(context: @context, message: @first_error)
          end
        end
      end
    end
  end
end
