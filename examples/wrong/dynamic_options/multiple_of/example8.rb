# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module MultipleOf
      class Example8 < ApplicationService::Base
        output :number, type: Integer, multiple_of: 2

        make :assign_output

        private

        def assign_output
          outputs.number = 100_000_000_000_000_000_001
        end
      end
    end
  end
end
