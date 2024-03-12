# frozen_string_literal: true

module Usual
  module InternalOptionHelpers
    class Example1 < ApplicationService::Base
      input :invoice_numbers,
            type: Array,
            consists_of: String

      internal :invoice_numbers,
               :must_be_6_characters,
               type: Array,
               consists_of: String

      output :first_invoice_number, type: String

      make :assign_internal_invoice_numbers
      make :assign_first_invoice_number

      private

      def assign_internal_invoice_numbers
        internals.invoice_numbers = inputs.invoice_numbers
      end

      def assign_first_invoice_number
        outputs.first_invoice_number = internals.invoice_numbers.first
      end
    end
  end
end
