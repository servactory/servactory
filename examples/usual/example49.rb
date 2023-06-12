# frozen_string_literal: true

module Usual
  class Example49 < ApplicationService::Base
    output :number, type: Integer

    stage do
      only_if ->(**) { true }

      make :assign_number_6
    end

    stage do
      only_if ->(**) { false }

      make :assign_number_7
    end

    private

    def assign_number_6
      self.number = 6
    end

    def assign_number_7
      self.number = 7
    end
  end
end
