# frozen_string_literal: true

module Usual
  module OutputOptionHelpers
    class Example1 < ApplicationService::Base
      input :invoice_numbers,
            type: Array,
            consists_of: String

      output :invoice_numbers,
             :must_be_6_characters,
             type: Array,
             consists_of: String

      make :assign_output_invoice_numbers

      private

      def assign_output_invoice_numbers
        outputs.invoice_numbers = inputs.invoice_numbers
      end
    end
  end
end
