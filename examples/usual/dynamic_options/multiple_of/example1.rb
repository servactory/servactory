# frozen_string_literal: true

module Usual
  module DynamicOptions
    module MultipleOf
      class Example1 < ApplicationService::Base
        input :number, type: [Integer, Float, Rational, BigDecimal], multiple_of: 9

        internal :number, type: [Integer, Float, Rational, BigDecimal], multiple_of: 6

        output :number, type: [Integer, Float, Rational, BigDecimal], multiple_of: 5

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
