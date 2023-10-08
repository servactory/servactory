# frozen_string_literal: true

module Usual
  class Example67 < ApplicationService::Base
    input :ids,
          type: Set,
          of: {
            type: String,
            message: ->(input:, expected_type:) { "Input `#{input.name}` must be a collection of `#{expected_type}`" }
          }

    output :first_id, type: String

    make :assign_first_id

    private

    def assign_first_id
      outputs.first_id = inputs.ids.first
    end
  end
end
