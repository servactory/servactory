# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Output
        class Example21 < ApplicationService::Base
          output :success, type: String

          make :assign_success

          private

          def assign_success
            outputs.success = "test"
          end
        end
      end
    end
  end
end
