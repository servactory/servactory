# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Input
        class Example6 < ApplicationService::Base
          input :outputs, type: String

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
