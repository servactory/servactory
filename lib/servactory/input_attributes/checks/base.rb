# frozen_string_literal: true

module Servactory
  module InputAttributes
    module Checks
      class Base
        protected

        def add_error(message, **attributes)
          message = message.call(**attributes) if message.is_a?(Proc)

          errors << message
        end

        private

        def errors
          @errors ||= Errors.new
        end
      end
    end
  end
end
