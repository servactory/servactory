# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Date
        module Optional
          class Example2 < ApplicationService::Base
            input :started_on, type: String, required: false

            internal :started_on, type: [String, NilClass], check_format: :date

            output :started_on, type: [::Date, NilClass]

            make :assign_internal

            make :assign_output

            private

            def assign_internal
              internals.started_on = inputs.started_on
            end

            def assign_output
              outputs.started_on = internals.started_on.present? ? ::Date.parse(internals.started_on) : nil
            end
          end
        end
      end
    end
  end
end
