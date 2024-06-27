# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Date
        module Optional
          class Example3 < ApplicationService::Base
            input :started_on, type: String, required: false

            output :started_on, type: [String, NilClass], format: :date

            make :assign_output

            private

            def assign_output
              outputs.started_on = inputs.started_on
            end
          end
        end
      end
    end
  end
end
