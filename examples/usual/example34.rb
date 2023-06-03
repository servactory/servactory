# frozen_string_literal: true

module Usual
  class Example34 < ApplicationService::Base
    input :invoice_numbers,
          type: String,
          array: true,
          must: {
            be_6_characters: {
              is: ->(value:) { value.all? { |id| id.size == 6 } },
              message: lambda do |input:, **|
                "Wrong IDs in `#{input.name}`"
              end
            }
          }

    output :first_invoice_number, type: String

    make :assign_first_invoice_number

    private

    def assign_first_invoice_number
      self.first_invoice_number = inputs.invoice_numbers.first
    end
  end
end
