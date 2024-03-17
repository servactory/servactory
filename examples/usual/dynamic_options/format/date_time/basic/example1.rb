# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module DateTime
        module Basic
          class Example1 < ApplicationService::Base
            input :started_at, type: String, format: :datetime

            output :started_at, type: ::DateTime

            make :assign_output

            private

            def assign_output
              outputs.started_at = ::DateTime.parse(inputs.started_at)
            end
          end
        end
      end
    end
  end
end
