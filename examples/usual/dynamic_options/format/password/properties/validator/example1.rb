# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Password
        module Properties
          module Validator
            class Example1 < ApplicationService::Base
              input :password,
                    type: String,
                    format: {
                      is: :password,
                      pattern: nil, # This will disable the value checking based on the pattern
                      validator: lambda do |value:|
                        value.size >= 9
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
