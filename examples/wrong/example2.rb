# frozen_string_literal: true

module Wrong
  class Example2 < ApplicationService::Base
    input :invoice_number, type: String

    output :invoice_number, type: Integer

    stage { make :assign_invoice_number }

    private

    def assign_invoice_number
      self.invoice_number = inputs.number
    end
  end
end
