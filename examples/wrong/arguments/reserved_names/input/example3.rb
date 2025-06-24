# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Input
        class Example3 < ApplicationService::Base
          input :internal, type: String

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
