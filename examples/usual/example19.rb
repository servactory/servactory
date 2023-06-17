# frozen_string_literal: true

module Usual
  class Example19 < ApplicationService::Base
    output :number, type: Integer

    make :assign_number

    private

    def assign_number
      outputs.number = 7
    end
  end
end
