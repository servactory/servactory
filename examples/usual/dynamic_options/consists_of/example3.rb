# frozen_string_literal: true

module Usual
  module DynamicOptions
    module ConsistsOf
      class Example3 < ApplicationService::Base
        input :invoice_numbers,
              type: Array,
              consists_of: String,
              must: {
                be_6_characters: {
                  is: lambda do |value:, **|
                    value.all? do |id|
                      return true if id.blank? # NOTE: This is not the responsibility of this `must` validator

                      (id.is_a?(Integer) ? id.abs.digits.length : id.size) == 6
                    end
                  end
                }
              }

        output :first_invoice_number, type: String

        make :assign_first_invoice_number

        private

        def assign_first_invoice_number
          outputs.first_invoice_number = inputs.invoice_numbers.first
        end
      end
    end
  end
end
