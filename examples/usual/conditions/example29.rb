# frozen_string_literal: true

module Usual
  module Conditions
    class Example29 < ApplicationService::Base
      output :number, type: Integer

      make :assign_number_7, if: true
      make :assign_number_6, if: false

      private

      def assign_number_7
        outputs.number = 7
      end

      def assign_number_6
        outputs.number = 6
      end
    end
  end
end
