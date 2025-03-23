# frozen_string_literal: true

module Usual
  module Conditions
    class Example6 < ApplicationService::Base
      input :locked, type: [TrueClass, FalseClass], required: false, default: true

      output :number, type: Integer

      make :lock!, if: ->(context:) { context.inputs.locked? }

      make :assign_number

      private

      def lock!
        fail!(message: "Locked!")
      end

      def assign_number
        outputs.number = 7
      end
    end
  end
end
