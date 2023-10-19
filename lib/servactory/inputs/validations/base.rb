# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Base
        private

        def add_error(message:, **attributes)
          message = message.call(**attributes) if message.is_a?(Proc)

          errors << message
        end

        def errors
          @errors ||= Errors.new
        end
      end
    end
  end
end
