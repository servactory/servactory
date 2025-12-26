# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Format
      module WrongType
        class Example1 < ApplicationService::Base
          # NOTE: This example tests the wrong_type error when a non-String value
          #       is passed with a format option for input.

          input :email, type: Integer, format: :email

          make :perform

          private

          def perform
            # ...
          end
        end
      end
    end
  end
end
