# frozen_string_literal: true

module Usual
  class Example5 < ApplicationService::Base
    input :ids, type: Array

    output :first_id, type: String

    stage { make :assign_first_id }

    private

    def assign_first_id
      self.first_id = inputs.ids[0]
    end
  end
end
