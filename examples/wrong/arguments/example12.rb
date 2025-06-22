# frozen_string_literal: true

module Wrong
  module Arguments
    class Example12 < ApplicationService::Base
      output :outputs, type: String

      make :assign_outputs

      private

      def assign_outputs
        outputs.outputs = "test"
      end
    end
  end
end
