# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Input
        class Example5 < ApplicationService::Base
          input :output, type: String

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
