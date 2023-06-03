# frozen_string_literal: true

module Usual
  class Example36Base < ApplicationService::Base
    output :number, type: Integer

    make :assign_number_6, position: 2

    private

    def assign_number_6
      self.number = 6
    end
  end

  class Example36 < Example36Base
    make :assign_number_7, position: 1

    def assign_number_7
      self.number = 7
    end
  end
end
