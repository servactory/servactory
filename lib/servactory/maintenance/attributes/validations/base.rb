# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Validations
        class Base
          # TODO: [SRV-404] This class may become unused after validators are rewritten
          #       to static methods approach. Type class no longer inherits from Base.
          #       Consider removing if Must is also rewritten to static.
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
end
