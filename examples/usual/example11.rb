# frozen_string_literal: true

module Usual
  class Example11 < ApplicationService::Base
    input :ids, type: Array, of: { type: String }

    output :first_id, type: String

    make :assign_first_id

    private

    def assign_first_id
      outputs.first_id = inputs.ids[0]
    end
  end
end
