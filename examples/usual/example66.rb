# frozen_string_literal: true

module Usual
  class Example66 < ApplicationService::Base
    input :ids,
          type: Set,
          consists_of: {
            type: String,
            message: "Input `ids` must be a collection of `String`"
          }

    output :first_id, type: String

    make :assign_first_id

    private

    def assign_first_id
      outputs.first_id = inputs.ids.first
    end
  end
end
