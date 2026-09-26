# frozen_string_literal: true

module Usual
  module Inheritance
    class Example4Base < ApplicationService::Base
      input :amount, type: String

      input :comment, type: String

      input :quantity,
            type: Integer,
            must: {
              be_positive: {
                is: ->(value:, **) { value.positive? },
                message: ->(input:, **) { "Input `#{input.name}` must be positive" }
              }
            }

      internal :total, type: String

      output :total, type: String

      make :assign_internal_total

      make :assign_output_total

      private

      def assign_internal_total
        internals.total = "#{inputs.amount} x #{inputs.quantity}"
      end

      def assign_output_total
        outputs.total = internals.total
      end
    end

    class Example4 < Example4Base
      input :amount, type: Integer

      input :comment, type: String, required: false

      input :quantity,
            type: Integer,
            must: {
              be_even: {
                is: ->(value:, **) { value.even? },
                message: ->(input:, **) { "Input `#{input.name}` must be even" }
              }
            }

      internal :total, type: Integer

      output :total, type: Integer

      private

      def assign_internal_total
        internals.total = inputs.amount * inputs.quantity
      end
    end
  end
end
