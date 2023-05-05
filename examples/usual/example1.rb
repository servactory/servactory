# frozen_string_literal: true

module Usual
  class Example1 < ApplicationService::Base
    input :first_name, type: String, internal: true
    input :middle_name, type: String, required: false, internal: true
    input :last_name, type: String, internal: true

    output :full_name, type: String

    stage { make :assign_full_name }

    private

    def assign_full_name
      self.full_name = [
        first_name,
        middle_name,
        last_name
      ].compact.join(" ")
    end
  end
end
