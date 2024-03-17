# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module DateTime
        module Is
          class Example1 < ApplicationService::Base
            input :started_at, type: String, format: { is: :datetime }

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
