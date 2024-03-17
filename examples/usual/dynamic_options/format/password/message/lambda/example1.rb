# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Password
        module Message
          module Lambda
            class Example1 < ApplicationService::Base
              input :password,
                    type: String,
                    format: {
                      is: :password,
                      message: lambda do |input:, value:, option_value:, **|
                        "Value `#{value}` does not match the format of `#{option_value}` in `#{input.name}`"
                      end
                    }

              output :password, type: String

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
