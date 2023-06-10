# frozen_string_literal: true

module Usual
  class Example46 < ApplicationService::Base
    input :invoice_numbers,
          :must_be_6_characters,
          type: String,
          array: true

    output :first_invoice_number, type: String

    make :assign_first_invoice_number

    private

    def assign_first_invoice_number
      self.first_invoice_number = inputs.invoice_numbers.first
    end
  end
end
