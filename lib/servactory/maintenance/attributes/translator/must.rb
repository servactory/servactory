# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Translator
        module Must
          module_function

          def default
            lambda do |service_class_name:, value:, code:, input_name: nil, internal_name: nil, output_name: nil|
              attribute_key, attribute_i18n, attribute_name = Servactory::Utils.define_attribute_name_with(
                input_name: input_name,
                internal_name: internal_name,
                output_name: output_name
              )

              I18n.t(
                "servactory.#{attribute_i18n}.validations.must.default_error",
                service_class_name: service_class_name,
                "#{attribute_key}_name": attribute_name,
                value: value,
                code: code
              )
            end
          end

          def syntax_error # rubocop:disable Metrics/MethodLength
            lambda do |
              service_class_name:,
              value:,
              code:,
              exception_message:,
              input_name: nil,
              internal_name: nil,
              output_name: nil
            | # do
              attribute_key, attribute_i18n, attribute_name = Servactory::Utils.define_attribute_name_with(
                input_name: input_name,
                internal_name: internal_name,
                output_name: output_name
              )

              I18n.t(
                "servactory.#{attribute_i18n}.validations.must.syntax_error",
                service_class_name: service_class_name,
                "#{attribute_key}_name": attribute_name,
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
