# frozen_string_literal: true

module Usual
  module DynamicOptions
    module MultipleOf
      class Example3 < ApplicationService::Base
        input :number,
              type: [Integer, Float, Rational, BigDecimal],
              multiple_of: {
                is: 9,
                message: "The input is an incorrect multiple"
              }

        internal :number,
                 type: [Integer, Float, Rational, BigDecimal],
                 multiple_of: {
                   is: 6,
                   message: "The internal is an incorrect multiple"
                 }

        output :number,
               type: [Integer, Float, Rational, BigDecimal],
               multiple_of: {
                 is: 5,
                 message: "The output is an incorrect multiple"
               }

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
