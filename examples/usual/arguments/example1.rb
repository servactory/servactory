# frozen_string_literal: true

module Usual
  module Arguments
    class Example1 < ApplicationService::Base
      input :invoice_number, type: [String, Integer]

      internal :invoice_number, type: [String, Integer]

      output :invoice_number, type: [String, Integer]

      make :assign_internal_invoice_number
      make :assign_output_invoice_number

      private

      def assign_internal_invoice_number
        internals.invoice_number = inputs.invoice_number
      end

      def assign_output_invoice_number
        outputs.invoice_number = internals.invoice_number
      end
    end
  end
end
