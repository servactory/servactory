# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Date
        module Optional
          class Example1 < ApplicationService::Base
            input :started_on, type: String, required: false, format: :date

            output :started_on, type: [::Date, NilClass]

            make :assign_output

            private

            def assign_output
              outputs.started_on = inputs.started_on.present? ? ::Date.parse(inputs.started_on) : nil
            end
          end
        end
      end
    end
  end
end
