# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Min
      class Example1 < ApplicationService::Base
        input :data, type: [Integer, String, Array], min: 1

        internal :data, type: [Integer, String, Array], min: 2

        output :data, type: [Integer, String, Array], min: 3

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
