# frozen_string_literal: true

module Servactory
  module Inputs
    module Validations
      class Base
        # TODO: [SRV-404] Consider rewriting validators to static methods approach
        #       like maintenance/attributes/validations/Type class.
        #       This would make Base unnecessary for this namespace.
        #       See: lib/servactory/maintenance/attributes/validations/type.rb

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
