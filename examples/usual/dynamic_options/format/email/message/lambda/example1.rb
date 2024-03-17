# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Email
        module Message
          module Lambda
            class Example1 < ApplicationService::Base
              input :email,
                    type: String,
                    format: {
                      is: :email,
                      message: lambda do |input:, value:, option_value:, **|
                        "Value `#{value}` does not match the format of `#{option_value}` in `#{input.name}`"
                      end
                    }

              output :email, type: String

              make :assign_output

              private

              def assign_output
                outputs.email = "No Reply <#{inputs.email}>"
              end
            end
          end
        end
      end
    end
  end
end
