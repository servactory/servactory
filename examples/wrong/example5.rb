# frozen_string_literal: true

module Wrong
  class Example5 < ApplicationService::Base
    input :invoice_number, type: String

    output :invoice_number, type: Integer

    make :assign_invoice_number

    private

    def assign_invoice_number
      self.invoice_number = inputs.invoice_number
    end
  end
end
