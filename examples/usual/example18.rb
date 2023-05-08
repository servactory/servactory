# frozen_string_literal: true

module Usual
  class Example18 < ApplicationService::Base
    input :first_name, type: String
    input :middle_name, type: String, required: false
    input :last_name, type: String

    internal :prepared_full_name, type: String

    output :full_name, type: String

    stage do
      make :prepare_full_name
    end

    stage do
      make :assign_full_name
    end

    private

    def prepare_full_name
      self.prepared_full_name = [
        inputs.first_name,
        inputs.middle_name,
        inputs.last_name
      ].compact.join(" ")
    end

    def assign_full_name
      self.full_name = prepared_full_name
    end
  end
end
