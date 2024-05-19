# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module DateTime
        module Optional
          class Example1 < ApplicationService::Base
            input :started_at, type: String, required: false, format: :datetime

            output :started_at, type: [::DateTime, NilClass]

            make :assign_output

            private

            def assign_output
              outputs.started_at = inputs.started_at.present? ? ::DateTime.parse(inputs.started_at) : nil
            end
          end
        end
      end
    end
  end
end
