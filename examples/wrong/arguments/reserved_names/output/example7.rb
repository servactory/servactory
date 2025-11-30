# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Output
        class Example7 < ApplicationService::Base
          output :failure, type: String

          make :assign_failure

          private

          def assign_failure
            outputs.failure = "test"
          end
        end
      end
    end
  end
end
