# frozen_string_literal: true

module Usual
  module Position
    class Example2Base < ApplicationService::Base
      output :number, type: Integer

      make :assign_number_6, position: 2

      private

      def assign_number_6
        outputs.number = 6
      end
    end

    class Example2 < Example2Base
      make :assign_number_7, position: 1

      def assign_number_7
        outputs.number = 7
      end
    end
  end
end
