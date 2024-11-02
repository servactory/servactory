# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Time
        module Optional
          class Example2 < ApplicationService::Base
            input :started_at, type: String, required: false

            internal :started_at, type: [String, NilClass], check_format: :time

            output :started_at, type: [::Time, NilClass]

            make :assign_internal

            make :assign_output

            private

            def assign_internal
              internals.started_at = inputs.started_at
            end

            def assign_output
              outputs.started_at = internals.started_at.present? ? ::Time.parse(internals.started_at) : nil
            end
          end
        end
      end
    end
  end
end
