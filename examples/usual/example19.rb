# frozen_string_literal: true

module Usual
  class Example19 < ApplicationService::Base
    output :number, type: Integer

    stage do
      make :assign_number
    end

    private

    def assign_number
      self.number = 7
    end
  end
end
