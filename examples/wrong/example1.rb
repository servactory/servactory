# frozen_string_literal: true

module Wrong
  class Example1 < ApplicationService::Base
    input :invoice_number, type: String

    internal :prepared_invoice_number, type: Integer

    output :invoice_number, type: String

    make :prepare_invoice_number
    make :assign_invoice_number

    private

    def prepare_invoice_number
      self.prepared_invoice_number = inputs.invoice_number
    end

    def assign_invoice_number
      self.invoice_number = prepared_invoice_number
    end
  end
end
