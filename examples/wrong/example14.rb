# frozen_string_literal: true

module Wrong
  class Example14 < ApplicationService::Base
    input :invoice_number, type: String

    output :prepared_invoice_number, type: Integer

    make :assign_invoice_number

    private

    def assign_invoice_number
      self.prepared_invoice_number = invoice_number
    end
  end
end
