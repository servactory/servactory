# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module DateTime
        module Properties
          module Pattern
            class Example1 < ApplicationService::Base
              # rubocop:disable Layout/LineLength
              input :started_at,
                    type: String,
                    format: {
                      is: :datetime,
                      pattern: /^(-?(?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(\.[0-9]+)?(Z|[+-](?:2[0-3]|[01][0-9]):[0-5][0-9])?$/
                    }
              # rubocop:enable Layout/LineLength

              output :started_at, type: ::DateTime

              make :assign_output

              private

              def assign_output
                outputs.started_at = ::DateTime.parse(inputs.started_at)
              end
            end
          end
        end
      end
    end
  end
end
