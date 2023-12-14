# frozen_string_literal: true

module Usual
  module Position
    class Example1 < ApplicationService::Base
      output :number, type: Integer

      make :assign_number_5, position: 3
      make :assign_number_6, position: 2
      make :assign_number_7, position: 1

      private

      def assign_number_5
        outputs.number = 5
      end

      def assign_number_6
        outputs.number = 6
      end

      def assign_number_7
        outputs.number = 7
      end
    end
  end
end
