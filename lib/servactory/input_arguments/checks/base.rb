# frozen_string_literal: true

module Servactory
  module InputArguments
    module Checks
      class Base
        protected

        def add_error(message, **arguments)
          message = message.call(**arguments) if message.is_a?(Proc)

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
