# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Format
      module WrongType
        class Example2 < ApplicationService::Base
          # NOTE: This example tests the wrong_type error when a Hash value
          #       is passed with a format option for input.

          input :identifier, type: Hash, format: :uuid

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
