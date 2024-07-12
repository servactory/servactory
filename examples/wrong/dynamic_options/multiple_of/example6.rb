# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module MultipleOf
      class Example6 < ApplicationService::Base
        output :number, type: Integer, multiple_of: 0

        make :assign_output

        private

        def assign_output
          outputs.number = 10
        end
      end
    end
  end
end
