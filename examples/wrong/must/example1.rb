# frozen_string_literal: true

module Wrong
  module Must
    class Example1 < ApplicationService::Base
      input :invoice_numbers,
            type: Array,
            consists_of: String,
            must: {
              be_6_characters: {
                is: ->(**) { this_method_does_not_exist }
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
