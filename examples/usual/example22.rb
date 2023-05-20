# frozen_string_literal: true

module Usual
  class Example22Parent1 < ApplicationService::Base
    input :input_1, type: String

    output :output_3, type: String

    make :assign_output_3

    private

    def assign_output_3
      self.output_3 = inputs.input_3
    end
  end

  class Example22Parent2 < Example22Parent1
    input :input_3, type: String

    output :output_1, type: String

    make :assign_output_1

    private

    def assign_output_1
      self.output_1 = inputs.input_1
    end
  end

  class Example22 < Example22Parent2
    input :input_2, type: String

    output :output_2, type: String

    make :assign_output_2

    private

    def assign_output_2
      self.output_2 = inputs.input_2
    end
  end
end
