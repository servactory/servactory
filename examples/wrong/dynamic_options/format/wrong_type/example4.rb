# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Format
      module WrongType
        class Example4 < ApplicationService::Base
          # NOTE: This example tests the wrong_type error when a non-String value
          #       is passed with a format option for output.

          input :value, type: Integer

          output :email, type: Integer, format: :email

          make :assign_output

          private

          def assign_output
            outputs.email = inputs.value
          end
        end
      end
    end
  end
end
