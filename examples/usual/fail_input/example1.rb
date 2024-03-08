# frozen_string_literal: true

module Usual
  module FailInput
    class Example1 < ApplicationService::Base
      input :invoice_number, type: String

      output :invoice_number, type: String

      make :check_input_invoice_number!
      make :assign_output_invoice_number

      private

      def check_input_invoice_number!
        return if inputs.invoice_number.start_with?("AA")

        fail_input!(
          :invoice_number,
          message: "Invalid invoice number",
          meta: {
            received_invoice_number: inputs.invoice_number
          }
        )
      end

      def assign_output_invoice_number
        outputs.invoice_number = inputs.invoice_number
      end
    end
  end
end
