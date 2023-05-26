# frozen_string_literal: true

module Usual
  class Example28 < ApplicationService::Base
    output :number, type: Integer

    assign :number

    private

    def assign_number
      self.number = 7
    end
  end
end
