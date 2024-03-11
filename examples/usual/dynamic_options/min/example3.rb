# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Min
      class Example3 < ApplicationService::Base
        input :data,
              type: [Integer, String, Array, ::Hash],
              min: {
                is: 1,
                message: "The input value must not be less than the specified value"
              }

        internal :data,
                 type: [Integer, String, Array, ::Hash],
                 minimum: {
                   is: 2,
                   message: "The internal value must not be less than the specified value"
                 }

        output :data,
               type: [Integer, String, Array, ::Hash],
               min: {
                 is: 3,
                 message: "The output value must not be less than the specified value"
               }

        make :assign_internal_data

        make :assign_output_data

        private

        def assign_internal_data
          internals.data = inputs.data
        end

        def assign_output_data
          outputs.data = internals.data
        end
      end
    end
  end
end
