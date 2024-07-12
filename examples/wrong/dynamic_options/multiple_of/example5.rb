# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module MultipleOf
      class Example5 < ApplicationService::Base
        output :number, type: Integer, multiple_of: nil

        make :assign_output

        private

        def assign_output
          outputs.number = 10
        end
      end
    end
  end
end
