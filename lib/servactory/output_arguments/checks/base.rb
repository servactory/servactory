# frozen_string_literal: true

module Servactory
  module OutputArguments
    module Checks
      class Base
        protected

        def raise_error_with(message, **arguments)
          message = message.call(**arguments) if message.is_a?(Proc)

          raise Servactory.configuration.output_argument_error_class.new(message: message)
        end
      end
    end
  end
end
