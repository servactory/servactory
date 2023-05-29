# frozen_string_literal: true

module Usual
  class Example31 < ApplicationService::Base
    output :number, type: Integer

    make :assign_number_7, unless: false
    make :assign_number_6, unless: true

    private

    def assign_number_7
      self.number = 7
    end

    def assign_number_6
      self.number = 6
    end
  end
end
