# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Format
      module WrongType
        class Example3 < ApplicationService::Base
          # NOTE: This example tests the wrong_type error when a non-String value
          #       is passed with a format option for internal.

          input :value, type: Integer

          internal :email, type: Integer, check_format: :email

          make :assign_internal

          private

          def assign_internal
            internals.email = inputs.value
          end
        end
      end
    end
  end
end
