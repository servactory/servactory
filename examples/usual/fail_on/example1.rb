# frozen_string_literal: true

module Usual
  module FailOn
    class Example1 < ApplicationService::Base
      LikeAnActiveRecordException = Class.new(ArgumentError)

      fail_on! LikeAnActiveRecordException

      input :invoice_number, type: String

      output :invoice_number, type: String

      make :check_invoice_number!
      make :assign_invoice_number

      private

      def check_invoice_number!
        return if inputs.invoice_number.start_with?("AA")

        raise LikeAnActiveRecordException, "Invalid invoice number"
      end

      def assign_invoice_number
        outputs.invoice_number = inputs.invoice_number
      end
    end
  end
end
