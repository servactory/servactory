# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Tools
        class ReservedNameValidator
          RESERVED = {
            input: %i[fail success],
            output: %i[failure success],
            internal: []
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
            when :input then Servactory::Exceptions::Input
            when :output then Servactory::Exceptions::Output
            when :internal then Servactory::Exceptions::Internal
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
