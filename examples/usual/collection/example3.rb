# frozen_string_literal: true

module Usual
  module Collection
    class Example3 < ApplicationService::Base
      input :invoice_numbers,
            type: Array,
            consists_of: String,
            must: {
              be_6_characters: {
                is: ->(value:, **) { value.all? { |id| id.size == 6 } }
              }
            }

      output :first_invoice_number, type: String

      make :assign_first_invoice_number

      private

      def assign_first_invoice_number
        outputs.first_invoice_number = inputs.invoice_numbers.first
      end
    end
  end
end
