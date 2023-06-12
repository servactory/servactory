# frozen_string_literal: true

module Usual
  class Example46 < ApplicationService::Base
    configuration do
      input_option_helpers(
        [
          Servactory::Inputs::OptionHelper.new(
            name: :must_be_6_characters,
            equivalent: {
              must: {
                be_6_characters: {
                  is: ->(value:) { value.all? { |id| id.size == 6 } },
                  message: lambda do |input:, **|
                    "Wrong IDs in `#{input.name}`"
                  end
                }
              }
            }
          )
        ]
      )
    end

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
