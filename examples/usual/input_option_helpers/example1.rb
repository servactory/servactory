# frozen_string_literal: true

module Usual
  module InputOptionHelpers
    class Example1 < ApplicationService::Base
      configuration do
        input_option_helpers(
          [
            Servactory::Maintenance::Attributes::OptionHelper.new(
              name: :must_be_6_characters,
              equivalent: {
                must: {
                  be_6_characters: {
                    is: ->(value:) { value.all? { |id| id.size == 6 } },
                    message: lambda do |input_name:, **|
                      "Wrong IDs in `#{input_name}`"
                    end
                  }
                }
              }
            )
          ]
        )
      end

      input :invoice_numbers,
            :must_be_6_characters,
            type: Array,
            consists_of: String

      output :first_invoice_number, type: String

      make :assign_first_invoice_number

      private

      def assign_first_invoice_number
        outputs.first_invoice_number = inputs.invoice_numbers.first
      end
    end
  end
end
