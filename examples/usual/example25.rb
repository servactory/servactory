# frozen_string_literal: true

module Usual
  class Example25 < ApplicationService::Base
    input :ids,
          type: String,
          array: { message: "Input `ids` must be an array of `String`" }

    output :first_id, type: String

    make :assign_first_id

    private

    def assign_first_id
      self.first_id = inputs.ids[0]
    end
  end
end
