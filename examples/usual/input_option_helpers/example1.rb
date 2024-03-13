# frozen_string_literal: true

module Usual
  module InputOptionHelpers
    class Example1 < ApplicationService::Base
      input :invoice_numbers,
            :must_be_6_characters,
            type: Array,
            consists_of: String

      output :first_invoice_number, type: String

      make :assign_first_invoice_number

      private

      def assign_first_invoice_number
        outputs.first_invoice_number = inputs.invoice_numbers.first
      end
    end
  end
end
