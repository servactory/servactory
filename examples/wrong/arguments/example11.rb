# frozen_string_literal: true

module Wrong
  module Arguments
    class Example11 < ApplicationService::Base
      output :output, type: String

      make :assign_output

      private

      def assign_output
        outputs.output = "test"
      end
    end
  end
end 