# frozen_string_literal: true

module Usual
  class Example50 < ApplicationService::Base
    input :invoice_number, type: String, internal: true

    output :invoice_number_tmp, type: String
    output :invoice_number, type: String

    make :check_invoice_number!,
         if: ->(context:) { context.invoice_number == "AA-7650AE" || context.invoice_number == "BB-7650AE" }

    make :assign_invoice_number_tmp
    make :assign_invoice_number

    private

    def check_invoice_number!
      return if invoice_number.start_with?("AA")

      fail!(message: "Invalid invoice number")
    end

    def assign_invoice_number_tmp
      self.invoice_number_tmp = invoice_number
    end

    def assign_invoice_number
      self.invoice_number = invoice_number_tmp
    end
  end
end
