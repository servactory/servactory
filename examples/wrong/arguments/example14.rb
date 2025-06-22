# frozen_string_literal: true

module Wrong
  module Arguments
    class Example14 < ApplicationService::Base
      output :inputs, type: String

      make :assign_inputs

      private

      def assign_inputs
        outputs.inputs = "test"
      end
    end
  end
end
