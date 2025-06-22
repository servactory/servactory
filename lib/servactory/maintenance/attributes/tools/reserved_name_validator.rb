# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Tools
        module ReservedNameValidator
          RESERVED = {
            input: %i[fail success],
            output: %i[failure success],
            internal: []
          }.freeze

          def self.validate!(context:, attribute:)
            name = attribute.respond_to?(:name) ? attribute.name.to_sym : nil
            type =
              if attribute.respond_to?(:input?) && attribute.input?
                :input
              elsif attribute.respond_to?(:output?) && attribute.output?
                :output
              elsif attribute.respond_to?(:internal?) && attribute.internal?
                :internal
              end
            return unless name && type && RESERVED[type]&.include?(name)

            exception_class = case type
                             when :input then Servactory::Exceptions::Input
                             when :output then Servactory::Exceptions::Output
                             when :internal then Servactory::Exceptions::Internal
                             end

            raise exception_class.new(
              context: context,
              message: "[#{context.class.name}] Имя :#{name} зарезервировано для #{type}s",
              "#{type}_name": name
            )
          end
        end
      end
    end
  end
end 