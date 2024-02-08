# frozen_string_literal: true

module Usual
  module InputOptionHelpers
    class Example3 < ApplicationService::Base
      input :number_of_calls,
            type: Integer,
            min: {
              is: 2,
              message: lambda do |input_name:, expected_value:, given_value:|
                "The value of `#{input_name}` must be greater than or equal to `#{expected_value}` (got: `#{given_value}`)"
              end
            },
            max: {
              is: 21,
              message: lambda do |input_name:, expected_value:, given_value:|
                "The value of `#{input_name}` must be less than or equal to `#{expected_value}` (got: `#{given_value}`)"
              end
            }

      internal :number_of_calls, type: Integer, min: 2, max: 19

      output :number_of_calls, type: Integer, min: 3, max: 18

      make :assign_internal_number_of_calls

      make :assign_output_number_of_calls

      private

      def assign_internal_number_of_calls
        internals.number_of_calls = inputs.number_of_calls
      end

      def assign_output_number_of_calls
        outputs.number_of_calls = internals.number_of_calls
      end
    end
  end
end
