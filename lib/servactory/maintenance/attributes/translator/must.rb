# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Translator
        module Must
          module_function

          def default_message
            lambda do |service:, value:, code:, input: nil, internal: nil, output: nil, reason: nil, **|
              attribute = Servactory::Utils.define_attribute_with(input:, internal:, output:)

              service.translate(
                "#{attribute.i18n_name}.validations.must.default_error",
                "#{attribute.system_name}_name": attribute.name,
                value:,
                code:,
                reason:
              )
            end
          end

          def syntax_error_message
            lambda do |service:, value:, code:, exception_message:, input: nil, internal: nil, output: nil|
              attribute = Servactory::Utils.define_attribute_with(input:, internal:, output:)

              service.translate(
                "#{attribute.i18n_name}.validations.must.syntax_error",
                "#{attribute.system_name}_name": attribute.name,
                value:,
                code:,
                exception_message:
              )
            end
          end
        end
      end
    end
  end
end
