# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Tools
        class ReservedNameValidator
          RESERVED = {
            input: %i[fail success],
            internal: [],
            output: %i[failure success]
          }.freeze
          private_constant :RESERVED

          def self.validate!(...)
            new(...).validate!
          end

          def initialize(context:, attribute:)
            @context = context
            @attribute = attribute
          end

          def validate!
            return unless reserved_name?

            raise_exception!
          end

          private

          attr_reader :context, :attribute

          def reserved_name?
            attribute.name && attribute.system_name && RESERVED[attribute.system_name]&.include?(attribute.name)
          end

          def exception_class
            case attribute.system_name
            when :input then @context.class.config.input_exception_class
            when :internal then @context.class.config.internal_exception_class
            when :output then @context.class.config.output_exception_class
            else
              raise ArgumentError, "Unable to determine attribute exception class. " \
                                   "Attribute: `#{attribute.system_name}`."
            end
          end

          def raise_exception!
            raise exception_class.new(
              context:,
              message: exception_message,
              "#{attribute.system_name}_name": attribute.name
            )
          end

          def exception_message
            service = context.send(:servactory_service_info)
            service.translate(
              "#{attribute.i18n_name}.tools.reserved_name",
              "#{attribute.system_name}_name": attribute.name
            )
          end
        end
      end
    end
  end
end
