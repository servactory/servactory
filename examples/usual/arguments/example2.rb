# frozen_string_literal: true

module Usual
  module Arguments
    class Example2 < ApplicationService::Base
      input :invoice_number, type: String

      internal :invoice_number, type: String

      output :invoice_number, type: String

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
