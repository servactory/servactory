# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class OptionHelperRulesService < ApplicationService::Base
          configuration do
            input_option_helpers(
              [
                Servactory::Maintenance::Options::Helper.new(
                  name: :max_length,
                  equivalent: lambda do |max|
                    {
                      must: {
                        be_short: {
                          is: ->(value:, **) { value.size <= max },
                          message: ->(input:, value:, **) { "Input `#{input.name}` is too long: #{value.size}" }
                        }
                      }
                    }
                  end
                )
              ]
            )
          end

          input :email,
                type: String,
                format: :email,
                must: {
                  be_corporate: {
                    is: ->(value:, **) { value.end_with?("@example.com") },
                    message: "Email must be corporate"
                  }
                }

          input :age, type: Integer, min: 18, max: 120

          input :quantity, type: Integer, multiple_of: 5

          input :code, type: String, custom_eq: "A"

          input :title, type: String, max_length: 10

          input :invoice_numbers,
                :must_be_6_characters,
                type: Array,
                consists_of: String

          internal :handler, type: Class, expect: String

          def call
            internals.handler = String
          end
        end
      end
    end
  end
end
