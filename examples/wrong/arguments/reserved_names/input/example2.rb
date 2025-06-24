# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Input
        class Example2 < ApplicationService::Base
          input :inputs, type: String

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
