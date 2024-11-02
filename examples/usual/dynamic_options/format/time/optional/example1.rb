# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Time
        module Optional
          class Example1 < ApplicationService::Base
            input :started_at, type: String, required: false, format: :time

            output :started_at, type: [::Time, NilClass]

            make :assign_output

            private

            def assign_output
              outputs.started_at = inputs.started_at.present? ? ::Time.parse(inputs.started_at) : nil
            end
          end
        end
      end
    end
  end
end
