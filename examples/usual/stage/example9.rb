# frozen_string_literal: true

module Usual
  module Stage
    class Example9 < ApplicationService::Base
      output :number, type: Integer

      stage do
        only_unless false

        make :assign_number_6
      end

      stage do
        only_unless true

        make :assign_number_7
      end

      private

      def assign_number_6
        outputs.number = 6
      end

      def assign_number_7
        outputs.number = 7
      end
    end
  end
end
