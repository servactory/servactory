# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Translator
        module Must
          module_function

          def default
            lambda do |service_class_name:, value:, code:, input: nil, internal: nil, output: nil|
              attribute = Servactory::Utils.define_attribute_with(input: input, internal: internal, output: output)

              I18n.t(
                "servactory.#{attribute.i18n_name}.validations.must.default_error",
                service_class_name: service_class_name,
                "#{attribute.system_name}_name": attribute.name,
                value: value,
                code: code
              )
            end
          end

          def syntax_error # rubocop:disable Metrics/MethodLength
            lambda do |service_class_name:, value:, code:, exception_message:, input: nil, internal: nil, output: nil|
              attribute = Servactory::Utils.define_attribute_with(input: input, internal: internal, output: output)

              I18n.t(
                "servactory.#{attribute.i18n_name}.validations.must.syntax_error",
                service_class_name: service_class_name,
                "#{attribute.system_name}_name": attribute.name,
                value: value,
                code: code,
                exception_message: exception_message
              )
            end
          end
        end
      end
    end
  end
end
