# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module MultipleOf
      class Example11 < ApplicationService::Base
        output :number, type: Float, multiple_of: 1.0

        make :assign_output

        private

        def assign_output
          outputs.number = -1.0e-20
        end
      end
    end
  end
end
