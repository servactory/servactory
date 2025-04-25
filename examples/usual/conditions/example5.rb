# frozen_string_literal: true

# FIXME: REWRITE ME
module Usual
  module Conditions
    class Example5 < ApplicationService::Base
      input :invoice_number, type: String

      output :invoice_number_tmp, type: String
      output :invoice_number, type: String

      make :check_invoice_number!,
           if: (lambda do |context:|
             %w[AA-7650AE BB-7650AE].include?(context.inputs.invoice_number)
           end)

      make :assign_invoice_number_tmp
      make :assign_invoice_number

      private

      def check_invoice_number!
        return if inputs.invoice_number.start_with?("AA")

        fail!(message: "Invalid invoice number")
      end

      def assign_invoice_number_tmp
        outputs.invoice_number_tmp = inputs.invoice_number
      end

      def assign_invoice_number
        outputs.invoice_number = outputs.invoice_number_tmp
      end
    end
  end
end
