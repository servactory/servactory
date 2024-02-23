# frozen_string_literal: true

module Usual
  module InternalOptionHelpers
    class Example1 < ApplicationService::Base
      configuration do
        internal_option_helpers(
          [
            Servactory::Maintenance::Attributes::OptionHelper.new(
              name: :must_be_6_characters,
              equivalent: {
                must: {
                  be_6_characters: {
                    is: ->(value:) { value.all? { |id| id.size == 6 } },
                    message: lambda do |internal:, **|
                      "Wrong IDs in `#{internal.name}`"
                    end
                  }
                }
              }
            )
          ]
        )
      end

      input :invoice_numbers,
            type: Array,
            consists_of: String

      internal :invoice_numbers,
               :must_be_6_characters,
               type: Array,
               consists_of: String

      output :first_invoice_number, type: String

      make :assign_internal_invoice_numbers
      make :assign_first_invoice_number

      private

      def assign_internal_invoice_numbers
        internals.invoice_numbers = inputs.invoice_numbers
      end

      def assign_first_invoice_number
        outputs.first_invoice_number = internals.invoice_numbers.first
      end
    end
  end
end
