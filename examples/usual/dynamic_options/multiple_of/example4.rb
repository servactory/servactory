# frozen_string_literal: true

module Usual
  module DynamicOptions
    module MultipleOf
      class Example4 < ApplicationService::Base
        # NOTE: This example tests Float type with numeric divisors.
        #       Using Integer-like Float divisors (2.0, 3.0, 5.0) avoids
        #       IEEE 754 precision issues with decimal fractions like 0.1.

        input :number, type: Float, multiple_of: 2.0

        internal :number, type: Float, divisible_by: 3.0

        output :number, type: Float, multiple_of: 5.0

        make :assign_internal_number

        make :assign_output_number

        private

        def assign_internal_number
          internals.number = inputs.number
        end

        def assign_output_number
          outputs.number = internals.number
        end
      end
    end
  end
end
