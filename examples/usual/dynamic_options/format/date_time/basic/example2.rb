# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module DateTime
        module Basic
          class Example2 < ApplicationService::Base
            input :started_at, type: String

            internal :started_at, type: String, check_format: :datetime

            output :started_at, type: ::DateTime

            make :assign_internal

            make :assign_output

            private

            def assign_internal
              internals.started_at = inputs.started_at
            end

            def assign_output
              outputs.started_at = ::DateTime.parse(internals.started_at)
            end
          end
        end
      end
    end
  end
end
