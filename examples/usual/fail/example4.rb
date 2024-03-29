# frozen_string_literal: true

module Usual
  module Fail
    class Example4 < ApplicationService::Base
      input :invoice_number, type: String

      output :invoice_number, type: String

      make :assign_invoice_number
      make :check_invoice_number!

      private

      def assign_invoice_number
        outputs.invoice_number = inputs.invoice_number
      end

      def check_invoice_number!
        return if outputs.invoice_number.start_with?("AA")

        fail!(message: "Invalid invoice number")
      end
    end
  end
end
