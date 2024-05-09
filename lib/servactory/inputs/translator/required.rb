# frozen_string_literal: true

module Servactory
  module Inputs
    module Translator
      module Required
        module_function

        def default_message
          lambda do |service:, input:, **|
            I18n.t(
              "servactory.inputs.validations.required.default_error.default",
              service_class_name: service.class_name,
              input_name: input.name
            )
          end
        end
      end
    end
  end
end
