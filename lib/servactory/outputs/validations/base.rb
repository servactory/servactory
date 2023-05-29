# frozen_string_literal: true

module Servactory
  module Outputs
    module Validations
      class Base
        protected

        def raise_error_with(message, **attributes)
          message = message.call(**attributes) if message.is_a?(Proc)

          raise Servactory.configuration.output_error_class.new(message: message)
        end
      end
    end
  end
end
