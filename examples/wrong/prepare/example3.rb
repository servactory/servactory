# frozen_string_literal: true

module Wrong
  module Prepare
    class Example3 < ApplicationService::Base
      input :number,
            type: [Integer, String],
            prepare: (lambda do |value:, inputs:|
              if inputs.preparation_enabled
                value.to_i
              else
                value
              end
            end)

      # NOTE: This input is missing.
      # input :preparation_enabled,
      #       type: [TrueClass, FalseClass],
      #       required: false,
      #       default: true

      output :number, type: [Integer, String]

      make :assign_number

      private

      def assign_number
        outputs.number = inputs.number
      end
    end
  end
end
