# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Output
        class Example3 < ApplicationService::Base
          output :internal, type: String

          make :assign_internal

          private

          def assign_internal
            outputs.internal = "test"
          end
        end
      end
    end
  end
end
