# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Input
        class Example9 < ApplicationService::Base
          input :success, type: String

          make :smth

          private

          def smth
            # ...
          end
        end
      end
    end
  end
end
