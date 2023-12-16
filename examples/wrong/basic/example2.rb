# frozen_string_literal: true

module Wrong
  module Basic
    class Example2 < ApplicationService::Base
      input :invoice_number, type: String

      output :invoice_number, type: Integer

      make :assign_invoice_number

      private

      def assign_invoice_number
        outputs.invoice_number = inputs.number
      end
    end
  end
end
