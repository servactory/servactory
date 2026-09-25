# frozen_string_literal: true

module Usual
  module Type
    class Example1 < ApplicationService::Base
      input :number,
            type: {
              is: [Integer, Float, String],
              message: "Input `number` must be an Integer, a Float or a String"
            }

      internal :number,
               type: {
                 is: [Integer, Float],
                 message: "Internal attribute `number` must be an Integer or a Float"
               }

      output :number,
             type: {
               is: Integer,
               message: "Output attribute `number` must be an Integer"
             }

      make :assign_internal_number

      make :assign_output_number

      private

      def assign_internal_number
        internals.number = inputs.number
      end

      def assign_output_number
        outputs.number = internals.number
      end
    end
  end
end
