# frozen_string_literal: true

module Usual
  class Example64Base < ApplicationService::Base
    input :number, type: Integer

    output :number, type: Integer

    make :assign_number_part_1
    make :assign_number_part_2

    private

    def assign_number_part_1
      outputs.number = inputs.number
    end

    def assign_number_part_2
      # skip
    end
  end

  class Example64 < Example64Base
    private

    def assign_number_part_2
      super

      outputs.number = outputs.number * 2
    end
  end
end

Usual::Example64.instance_override do
  def assign_number_part_2
    super

    outputs.number = outputs.number * 4
  end
end
