# frozen_string_literal: true

module Wrong
  class Example11 < ApplicationService::Base
    input :ids, as: :array_of_ids, type: String, array: true

    output :first_id, type: String

    make :assign_first_id

    private

    def assign_first_id
      self.first_id = inputs.ids[0]
    end
  end
end
