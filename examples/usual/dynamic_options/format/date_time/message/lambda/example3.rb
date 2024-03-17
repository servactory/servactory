# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module DateTime
        module Message
          module Lambda
            class Example3 < ApplicationService::Base
              input :started_at, type: String

              output :started_at,
                     type: String,
                     format: {
                       is: :datetime,
                       message: lambda do |output:, value:, option_value:, **|
                         "Value `#{value}` does not match the format of `#{option_value}` in `#{output.name}`"
                       end
                     }

              make :assign_output

              private

              def assign_output
                outputs.started_at = inputs.started_at
              end
            end
          end
        end
      end
    end
  end
end
