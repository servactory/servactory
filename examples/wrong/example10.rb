# frozen_string_literal: true

module Wrong
  class Example10 < ApplicationService::Base
    input :invoice_numbers,
          type: String,
          array: true,
          must: {
            be_6_characters: {
              is: ->(**) { this_method_does_not_exist }
            }
          }

    output :first_invoice_number, type: String

    stage { make :assign_first_invoice_number }

    private

    def assign_first_invoice_number
      self.first_invoice_number = inputs.invoice_numbers.first
    end
  end
end
