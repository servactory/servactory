# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Min
      class Example2 < ApplicationService::Base
        input :data,
              type: [Integer, String, Array, ::Hash],
              min: {
                is: 1,
                message: lambda do |input:, value:, option_value:, **|
                  "The size of the `#{input.name}` value must be greater than or " \
                    "equal to `#{option_value}` (got: `#{value}`)"
                end
              }

        internal :data,
                 type: [Integer, String, Array, ::Hash],
                 minimum: {
                   is: 2,
                   message: lambda do |internal:, value:, option_value:, **|
                     "The size of the `#{internal.name}` value must be greater than or " \
                       "equal to `#{option_value}` (got: `#{value}`)"
                   end
                 }

        output :data,
               type: [Integer, String, Array, ::Hash],
               min: {
                 is: 3,
                 message: lambda do |output:, value:, option_value:, **|
                   "The size of the `#{output.name}` value must be greater than or " \
                     "equal to `#{option_value}` (got: `#{value}`)"
                 end
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
