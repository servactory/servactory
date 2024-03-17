# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Email
        module Properties
          module Validator
            class Example1 < ApplicationService::Base
              input :email,
                    type: String,
                    format: {
                      is: :email,
                      pattern: nil, # This will disable the value checking based on the pattern
                      validator: lambda do |value:|
                        value.split(" at ").size == 2
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
