# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Time
        module Message
          module Static
            class Example1 < ApplicationService::Base
              input :started_at,
                    type: String,
                    format: {
                      is: :time,
                      message: "Invalid time format"
                    }

              output :started_at, type: ::Time

              make :assign_output

              private

              def assign_output
                outputs.started_at = ::Time.parse(inputs.started_at)
              end
            end
          end
        end
      end
    end
  end
end
