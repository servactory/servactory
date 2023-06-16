# frozen_string_literal: true

module Wrong
  class Example15 < ApplicationService::Base
    input :invoice_number, type: String, internal: true

    output :prepared_invoice_number, type: Integer

    make :assign_invoice_number

    private

    def assign_invoice_number
      outputs.prepared_invoice_number = inputs.invoice_number
    end
  end
end
