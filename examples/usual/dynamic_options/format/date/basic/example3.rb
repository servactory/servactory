# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Date
        module Basic
          class Example3 < ApplicationService::Base
            input :started_on, type: String

            output :started_on, type: String, format: :date

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
