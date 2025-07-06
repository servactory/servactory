# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Input
        class Example7 < ApplicationService::Base
          input :fail, type: String

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
