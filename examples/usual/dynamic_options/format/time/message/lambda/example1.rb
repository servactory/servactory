# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Time
        module Message
          module Lambda
            class Example1 < ApplicationService::Base
              input :started_at,
                    type: String,
                    format: {
                      is: :time,
                      message: lambda do |input:, value:, option_value:, **|
                        "Value `#{value}` does not match the format of `#{option_value}` in `#{input.name}`"
                      end
                    }

              output :started_at, type: ::Time

              make :assign_output

              private

              def assign_output
                outputs.started_at = ::Time.zone.parse(inputs.started_at)
              end
            end
          end
        end
      end
    end
  end
end
