# frozen_string_literal: true

module Usual
  module DynamicOptions
    module MultipleOf
      class Example2 < ApplicationService::Base
        input :number,
              type: [Integer, Float, Rational, BigDecimal],
              multiple_of: {
                is: 9,
                message: lambda do |input:, value:, option_value:, **|
                  "Input `#{input.name}` has the value `#{value}`, " \
                    "which is not a multiple of `#{option_value}`"
                end
              }

        internal :number,
                 type: [Integer, Float, Rational, BigDecimal],
                 multiple_of: {
                   is: 6,
                   message: lambda do |internal:, value:, option_value:, **|
                     "Internal `#{internal.name}` has the value `#{value}`, " \
                       "which is not a multiple of `#{option_value}`"
                   end
                 }

        output :number,
               type: [Integer, Float, Rational, BigDecimal],
               multiple_of: {
                 is: 5,
                 message: lambda do |output:, value:, option_value:, **|
                   "Output `#{output.name}` has the value `#{value}`, " \
                     "which is not a multiple of `#{option_value}`"
                 end
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
