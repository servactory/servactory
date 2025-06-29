# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Tools
        class ReservedNames
          def self.check!(...)
            new(...).check!
          end

          def initialize(context, collection)
            @context = context
            @collection = collection
          end

          def check!
            attribute = @collection.find do |attribute|
              self.class::RESERVED_NAMES.include?(attribute.name)
            end

            return if attribute.nil?

            raise_exception_for(attribute)
          end

          private

          def raise_exception_for(attribute)
            @context.send(
              fail_method_for(attribute),
              attribute.name,
              message: exception_message_for(attribute)
            )
          end

          ######################################################################

          def fail_method_for(attribute)
            case attribute.system_name
            when :input then :fail_input!
            when :internal then :fail_internal!
            when :output then :fail_output!
            else
              raise ArgumentError,
                    "Unable to determine attribute exception class. " \
                    "Attribute: `#{attribute.system_name}`."
            end
          end

          def exception_message_for(attribute)
            @context.send(:servactory_service_info).translate(
              "#{attribute.i18n_name}.tools.reserved_names.error",
              "#{attribute.system_name}_name": attribute.name
            )
          end
        end
      end
    end
  end
end
