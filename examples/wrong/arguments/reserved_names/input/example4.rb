# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Input
        class Example4 < ApplicationService::Base
          input :internals, type: String

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
