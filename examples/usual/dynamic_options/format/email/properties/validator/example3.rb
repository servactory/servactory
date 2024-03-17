# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Email
        module Properties
          module Validator
            class Example3 < ApplicationService::Base
              input :email, type: String

              output :email,
                     type: String,
                     format: {
                       is: :email,
                       pattern: nil, # This will disable the value checking based on the pattern
                       validator: lambda do |value:|
                         value.split(" at ").size == 2
                       end
                     }

              make :assign_output

              private

              def assign_output
                outputs.email = inputs.email
              end
            end
          end
        end
      end
    end
  end
end
