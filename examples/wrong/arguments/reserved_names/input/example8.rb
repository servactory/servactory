# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Input
        class Example8 < ApplicationService::Base
          input :failure, type: String

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
