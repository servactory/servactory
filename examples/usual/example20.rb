# frozen_string_literal: true

module Usual
  class Example20 < ApplicationService::Base
    input :invoice_number, type: String

    output :invoice_number, type: String

    make :check_invoice_number!
    make :assign_invoice_number

    private

    def check_invoice_number!
      return if inputs.invoice_number.start_with?("AA")

      fail!(message: "Invalid invoice number")
    end

    def assign_invoice_number
      self.invoice_number = inputs.invoice_number
    end
  end
end
