# frozen_string_literal: true

module Usual
  module Stage
    class Example16 < ApplicationService::Base
      input :threshold, type: Integer

      output :number, type: Integer

      stage do
        only_if ->(context:) { context.inputs.threshold > 5 }

        make :assign_high_number
      end

      stage do
        only_unless ->(context:) { context.inputs.threshold > 5 }

        make :assign_low_number
      end

      private

      def assign_high_number
        outputs.number = 10
      end

      def assign_low_number
        outputs.number = 3
      end
    end
  end
end
