# frozen_string_literal: true

module Usual
  class Example21 < ApplicationService::Base
    input :ids, as: :array_of_ids, type: Array, of: String

    output :first_id, type: String

    make :assign_first_id

    private

    def assign_first_id
      outputs.first_id = inputs.array_of_ids[0]
    end
  end
end
