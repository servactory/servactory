# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Translator
        module Type
          module_function

          def default_message
            lambda do |service:, attribute:, expected_type:, given_type:, **|
              service.translate(
                "#{attribute.i18n_name}.validations.type.default_error.default",
                "#{attribute.system_name}_name": attribute.name,
                expected_type:,
                given_type:
              )
            end
          end
        end
      end
    end
  end
end
