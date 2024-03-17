# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Date
        module Properties
          module Pattern
            class Example1 < ApplicationService::Base
              input :started_on,
                    type: String,
                    format: {
                      is: :date,
                      pattern: /^([0-9]{4})-?(1[0-2]|0[1-9])-?(3[01]|0[1-9]|[12][0-9])$/
                    }

              output :started_on, type: ::Date

              make :assign_output

              private

              def assign_output
                outputs.started_on = ::Date.parse(inputs.started_on)
              end
            end
          end
        end
      end
    end
  end
end
