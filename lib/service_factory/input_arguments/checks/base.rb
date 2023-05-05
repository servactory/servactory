# frozen_string_literal: true

module ServiceFactory
  module InputArguments
    module Checks
      class Base
        def initialize
          @errors = []
        end

        attr_reader :errors

        protected

        def add_error(message, **arguments)
          message = message.call(**arguments) if message.is_a?(Proc)

          errors.push(message)
        end
      end
    end
  end
end
