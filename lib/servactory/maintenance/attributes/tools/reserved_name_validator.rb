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

          def self.validate!(context:, attribute:)
            new(context: context, attribute: attribute).validate!
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

          def name
            attribute.respond_to?(:name) ? attribute.name.to_sym : nil
          end

          def type
            return :input if attribute.respond_to?(:input?) && attribute.input?
            return :output if attribute.respond_to?(:output?) && attribute.output?
            return :internal if attribute.respond_to?(:internal?) && attribute.internal?
            nil
          end

          def reserved_name?
            name && type && RESERVED[type]&.include?(name)
          end

          def exception_class
            case type
            when :input then Servactory::Exceptions::Input
            when :output then Servactory::Exceptions::Output
            when :internal then Servactory::Exceptions::Internal
            end
          end

          def raise_exception!
            raise exception_class.new(
              context: context,
              message: exception_message,
              "#{type}_name": name
            )
          end

          def exception_message
            i18n_key = case type
                       when :input then "servactory.inputs.tools.reserved_name.error"
                       when :output then "servactory.outputs.tools.reserved_name.error"
                       when :internal then "servactory.internals.tools.reserved_name.error"
                       end
            attr_key = case type
                       when :input then :input_name
                       when :output then :output_name
                       when :internal then :internal_name
                       end
            I18n.t(
              i18n_key,
              service_class_name: context.class.name,
              attr_key => name
            )
          end
        end
      end
    end
  end
end 