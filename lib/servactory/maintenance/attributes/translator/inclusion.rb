# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Translator
        module Inclusion
          module_function

          def default_message # rubocop:disable Metrics/MethodLength
            lambda do |
              service_class_name:,
              value:,
              attribute_inclusion:,
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
                "servactory.#{attribute_i18n}.validations.inclusion.default_error",
                service_class_name: service_class_name,
                "#{attribute_key}_name": attribute_name,
                "#{attribute_key}_inclusion": attribute_inclusion,
                value: value
              )
            end
          end
        end
      end
    end
  end
end
