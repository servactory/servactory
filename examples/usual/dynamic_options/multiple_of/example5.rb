# frozen_string_literal: true

module Usual
  module DynamicOptions
    module MultipleOf
      class Example5 < ApplicationService::Base
        input :number, type: [Integer, Float, Rational, BigDecimal], multiple_of: 0.1

        internal :number, type: [Integer, Float, Rational, BigDecimal], divisible_by: -0.1

        output :number, type: [Integer, Float, Rational, BigDecimal], multiple_of: 0.05

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
