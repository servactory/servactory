# frozen_string_literal: true

module Wrong
  module Must
    class Example4 < ApplicationService::Base
      internal :invoice_numbers,
               type: Array,
               consists_of: String,
               must: {
                 be_6_characters: {
                   is: ->(value:) { value.all? { |id| id.size == 6 } },
                   message: lambda do |input_name:, **|
                     "Wrong IDs in `#{input_name}`"
                   end
                 }
               }

      output :first_invoice_number, type: String

      make :assign_invoice_numbers
      make :assign_first_invoice_number

      private

      def assign_invoice_numbers
        internals.invoice_numbers = %w[
          7650AE
          B4EA1B
          A7BC86XXX
          BD2D6B
        ]
      end

      def assign_first_invoice_number
        outputs.first_invoice_number = internals.invoice_numbers.first
      end
    end
  end
end
