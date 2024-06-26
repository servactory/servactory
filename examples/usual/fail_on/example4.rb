# frozen_string_literal: true

module Usual
  module FailOn
    class Example4 < ApplicationService::Base
      MyException1 = Class.new(ArgumentError)
      MyException2 = Class.new(ArgumentError)

      fail_on! MyException1, with: ->(exception:) { "#{exception.message} as 1" }
      fail_on! MyException2, with: ->(exception:) { "#{exception.message} as 2" }

      input :invoice_number, type: String

      output :invoice_number, type: String

      make :check_invoice_number!
      make :assign_invoice_number

      private

      def check_invoice_number!
        return if inputs.invoice_number.start_with?("AA")

        raise MyException1, "Invalid invoice number"
      end

      def assign_invoice_number
        outputs.invoice_number = inputs.invoice_number
      end
    end
  end
end
