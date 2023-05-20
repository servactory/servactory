# frozen_string_literal: true

module Usual
  class Example6 < ApplicationService::Base
    input :ids, type: String, array: true

    output :first_id, type: String

    make :assign_first_id

    private

    def assign_first_id
      self.first_id = inputs.ids[0]
    end
  end
end
