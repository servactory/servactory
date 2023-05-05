# frozen_string_literal: true

module Usual
  class Example4 < ApplicationService::Base
    input :first_name, type: String
    input :middle_name, type: String, required: false, default: "<unknown>"
    input :last_name, type: String

    output :full_name, type: String

    stage { make :assign_full_name }

    private

    def assign_full_name
      self.full_name = [
        inputs.first_name,
        inputs.middle_name,
        inputs.last_name
      ].compact.join(" ")
    end
  end
end
