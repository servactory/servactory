# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Boolean
        module Properties
          module Pattern
            class Example1 < ApplicationService::Base
              input :boolean,
                    type: String,
                    format: {
                      is: :boolean,
                      pattern: nil # This will disable the value checking based on the pattern
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
