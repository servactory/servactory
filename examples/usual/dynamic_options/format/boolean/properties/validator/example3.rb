# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Boolean
        module Properties
          module Validator
            class Example3 < ApplicationService::Base
              input :boolean, type: String

              output :boolean,
                     type: String,
                     format: {
                       is: :boolean,
                       pattern: nil, # This will disable the value checking based on the pattern
                       validator: lambda do |value:|
                         %w[true 1 yes on].include?(value&.downcase)
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
