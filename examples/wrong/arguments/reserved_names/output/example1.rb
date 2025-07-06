# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Output
        class Example1 < ApplicationService::Base
          output :input, type: String

          make :assign_input

          private

          def assign_input
            outputs.input = "test"
          end
        end
      end
    end
  end
end
