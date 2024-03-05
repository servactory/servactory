# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Translator
        module Inclusion
          module_function

          def default_message
            lambda do |service_class_name:, value:, input: nil, internal: nil, output: nil|
              attribute = Servactory::Utils.define_attribute_with(input: input, internal: internal, output: output)

              puts
              puts
              puts attribute.inspect
              puts
              puts

              I18n.t(
                "servactory.#{attribute.i18n_name}.validations.inclusion.default_error",
                service_class_name: service_class_name,
                "#{attribute.system_name}_name": attribute.name,
                "#{attribute.system_name}_inclusion": attribute.inclusion[:in],
                value: value
              )
            end
          end
        end
      end
    end
  end
end
