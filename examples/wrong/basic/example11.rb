# frozen_string_literal: true

module Wrong
  module Basic
    class Example11 < ApplicationService::Base
      input :invoice_number, type: String

      internal :prepared_invoice_number, type: String

      output :invoice_number, type: Integer

      make :assign_invoice_number

      private

      def assign_invoice_number
        outputs.invoice_number = internals.prepared_invoice_number
      end
    end
  end
end
