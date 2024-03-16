# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Date
        module Message
          module Lambda
            class Example3 < ApplicationService::Base
              input :started_on, type: String

              output :started_on,
                     type: String,
                     format: {
                       is: :date,
                       message: lambda do |output:, value:, option_value:, **|
                         "Value `#{value}` does not match the format of `#{option_value}` in `#{output.name}`"
                       end
                     }

              make :assign_output

              private

              def assign_output
                outputs.started_on = inputs.started_on
              end
            end
          end
        end
      end
    end
  end
end
