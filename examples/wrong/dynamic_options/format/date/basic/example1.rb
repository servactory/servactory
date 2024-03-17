# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Format
      module Date
        module Basic
          class Example1 < ApplicationService::Base
            input :started_on, type: String, format: nil

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
