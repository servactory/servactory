# frozen_string_literal: true

module Usual
  class Example64Base < ApplicationService::Base
    input :number, type: Integer

    output :number, type: Integer

    make :assign_number

    private

    def assign_number
      outputs.number = inputs.number
    end
  end

  class Example64 < Example64Base
    private

    def assign_number
      super

      outputs.number = outputs.number * 2
    end
  end
end
