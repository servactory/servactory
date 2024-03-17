# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module DateTime
        module Message
          module Lambda
            class Example1 < ApplicationService::Base
              input :started_at,
                    type: String,
                    format: {
                      is: :datetime,
                      message: lambda do |input:, value:, option_value:, **|
                        "Value `#{value}` does not match the format of `#{option_value}` in `#{input.name}`"
                      end
                    }

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
