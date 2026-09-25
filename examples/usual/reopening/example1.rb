# frozen_string_literal: true

module Usual
  module Reopening
    class Example1 < ApplicationService::Base
      input :number, type: Integer

      output :numbers, type: Array

      make :assign_number

      private

      def assign_number
        outputs.numbers = [inputs.number]
      end
    end

    Example1.call(number: 1)

    class Example1
      make :append_doubled_number

      stage do
        make :append_tripled_number
        make :append_quadrupled_number
      end

      private

      def append_doubled_number
        outputs.numbers = [*outputs.numbers, inputs.number * 2]
      end

      def append_tripled_number
        outputs.numbers = [*outputs.numbers, inputs.number * 3]
      end

      def append_quadrupled_number
        outputs.numbers = [*outputs.numbers, inputs.number * 4]
      end
    end
  end
end
