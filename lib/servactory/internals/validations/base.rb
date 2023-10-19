# frozen_string_literal: true

module Servactory
  module Internals
    module Validations
      class Base
        protected

        def raise_error_with(message:, **attributes)
          message = message.call(**attributes) if message.is_a?(Proc)

          raise @context.class.config.internal_error_class.new(message: message)
        end
      end
    end
  end
end
