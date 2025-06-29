# frozen_string_literal: true

module Usual
  module Prepare
    class Example2 < ApplicationService::Base
      input :number,
            type: [Integer, String],
            prepare: (lambda do |value:, inputs:|
              # NOTE: Testing an argument and its predicate.
              if inputs.preparation_enabled && inputs.preparation_enabled?
                value.to_i
              else
                value
              end
            end)

      input :preparation_enabled,
            type: [TrueClass, FalseClass],
            required: false,
            default: true

      output :number, type: [Integer, String]

      make :assign_number

      private

      def assign_number
        outputs.number = inputs.number
      end
    end
  end
end
