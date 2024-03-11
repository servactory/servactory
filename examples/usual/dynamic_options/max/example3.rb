# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Max
      class Example3 < ApplicationService::Base
        input :data,
              type: [Integer, String, Array, ::Hash],
              max: {
                is: 10,
                message: "The input value must not be greater than the specified value"
              }

        internal :data,
                 type: [Integer, String, Array, ::Hash],
                 maximum: {
                   is: 9,
                   message: "The internal value must not be greater than the specified value"
                 }

        output :data,
               type: [Integer, String, Array, ::Hash],
               max: {
                 is: 8,
                 message: "The output value must not be greater than the specified value"
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
