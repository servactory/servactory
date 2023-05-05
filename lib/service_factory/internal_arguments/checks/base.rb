# frozen_string_literal: true

module ServiceFactory
  module InternalArguments
    module Checks
      class Base
        protected

        def raise_error_with(message, **arguments)
          message = message.call(**arguments) if message.is_a?(Proc)

          raise ServiceFactory.configuration.internal_argument_error_class, message
        end
      end
    end
  end
end
