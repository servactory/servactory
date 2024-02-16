# frozen_string_literal: true

module Usual
  module Success
    class Example1 < ApplicationService::Base
      input :number, type: Integer

      output :number, type: Integer

      make :multiply_by_2

      make :complete_service!

      make :assign_number_2

      private

      def multiply_by_2
        outputs.number = inputs.number * 2
      end

      def complete_service!
        success! if inputs.number == 1
      end

      def multiply_by_4
        outputs.number = outputs.number * 4
      end
    end
  end
end
