# frozen_string_literal: true

module Wrong
  module Must
    class Example6 < ApplicationService::Base
      output :invoice_numbers,
             type: Array,
             consists_of: String,
             must: {
               be_6_characters: {
                 is: ->(value:, **) { value.all? { |id| id.size == 6 } },
                 message: lambda do |output:, **|
                   "Wrong IDs in `#{output.name}`"
                 end
               }
             }

      output :first_invoice_number, type: String

      make :assign_invoice_numbers
      make :assign_first_invoice_number

      private

      def assign_invoice_numbers
        outputs.invoice_numbers = %w[
          7650AE
          B4EA1B
          A7BC86XXX
          BD2D6B
        ]
      end

      def assign_first_invoice_number
        outputs.first_invoice_number = outputs.invoice_numbers.first
      end
    end
  end
end
