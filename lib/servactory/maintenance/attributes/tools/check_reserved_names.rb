# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Tools
        class CheckReservedNames
          RESERVED = {
            input: %i[
              input inputs internal internals output outputs
              fail
              failure success
            ],
            internal: %i[
              input inputs internal internals output outputs
            ],
            output: %i[
              input inputs internal internals output outputs
              failure success
              error
            ]
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

          attr_reader :context,
                      :attribute

          def reserved_name?
            RESERVED[attribute.system_name].include?(attribute.name)
          end

          def fail_method
            case attribute.system_name
            when :input then :fail_input!
            when :internal then :fail_internal!
            when :output then :fail_output!
            else
              raise ArgumentError, "Unable to determine attribute exception class. " \
                                   "Attribute: `#{attribute.system_name}`."
            end
          end

          def raise_exception!
            @context.send(
              fail_method,
              attribute.name,
              message: exception_message
            )
          end

          def exception_message
            @context.send(:servactory_service_info).translate(
              "#{attribute.i18n_name}.tools.reserved_name.error",
              "#{attribute.system_name}_name": attribute.name
            )
          end
        end
      end
    end
  end
end
