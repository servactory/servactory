# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Max
      class Example1 < ApplicationService::Base
        input :number_of_calls, type: Integer, min: 1, max: 20

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
end
