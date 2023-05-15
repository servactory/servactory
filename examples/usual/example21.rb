# frozen_string_literal: true

module Usual
  class Example21 < ApplicationService::Base
    input :ids, as: :array_of_ids, type: String, array: true

    output :first_id, type: String

    stage { make :assign_first_id }

    private

    def assign_first_id
      self.first_id = inputs.array_of_ids[0]
    end
  end
end
