# frozen_string_literal: true

module Usual
  class Example45 < ApplicationService::Base
    input :first_name, :internal, type: String
    input :middle_name, :internal, :optional, type: String
    input :last_name, :internal, type: String

    output :full_name, type: String

    make :assign_full_name

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
