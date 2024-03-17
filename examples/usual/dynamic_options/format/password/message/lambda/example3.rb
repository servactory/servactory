# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Password
        module Message
          module Lambda
            class Example3 < ApplicationService::Base
              input :password, type: String

              output :password,
                     type: String,
                     format: {
                       is: :password,
                       message: lambda do |output:, value:, option_value:, **|
                         "Value `#{value}` does not match the format of `#{option_value}` in `#{output.name}`"
                       end
                     }

              make :assign_output

              private

              def assign_output
                outputs.password = inputs.password
              end
            end
          end
        end
      end
    end
  end
end
