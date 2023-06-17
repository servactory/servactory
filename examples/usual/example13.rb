# frozen_string_literal: true

module Usual
  class Example13 < ApplicationService::Base
    input :ids,
          type: String,
          array: {
            is: true,
            message: ->(input:, expected_type:) { "Input `#{input.name}` must be an array of `#{expected_type}`" }
          }

    output :first_id, type: String

    make :assign_first_id

    private

    def assign_first_id
      outputs.first_id = inputs.ids[0]
    end
  end
end
