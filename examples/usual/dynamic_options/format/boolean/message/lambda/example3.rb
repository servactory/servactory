# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Boolean
        module Message
          module Lambda
            class Example3 < ApplicationService::Base
              input :boolean, type: String

              output :boolean,
                     type: String,
                     format: {
                       is: :boolean,
                       message: lambda do |output:, value:, option_value:, **|
                         "Value `#{value}` does not match the format of `#{option_value}` in `#{output.name}`"
                       end
                     }

              make :assign_output

              private

              def assign_output
                outputs.boolean = inputs.boolean
              end
            end
          end
        end
      end
    end
  end
end
