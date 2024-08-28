# frozen_string_literal: true

module Usual
  module DynamicOptions
    module MinMax
      class Example1 < ApplicationService::Base
        input :data, type: [Integer, String, Array, ::Hash], min: 1, max: 10

        internal :data, type: [Integer, String, Array, ::Hash], minimum: 2, maximum: 9

        output :data, type: [Integer, String, Array, ::Hash], min: 3, max: 8

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
