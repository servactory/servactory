# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Boolean
        module Properties
          module Validator
            class Example1 < ApplicationService::Base
              input :boolean,
                    type: String,
                    format: {
                      is: :boolean,
                      pattern: nil, # This will disable the value checking based on the pattern
                      validator: lambda do |value:|
                        %w[true 1 yes on].include?(value&.downcase)
                      end
                    }

              output :boolean, type: String

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
