# frozen_string_literal: true

module Wrong
  module Arguments
    class Example13 < ApplicationService::Base
      output :input, type: String

      make :assign_input

      private

      def assign_input
        outputs.input = "test"
      end
    end
  end
end
