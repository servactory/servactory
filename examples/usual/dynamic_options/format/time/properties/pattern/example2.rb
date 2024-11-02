# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Time
        module Properties
          module Pattern
            class Example2 < ApplicationService::Base
              input :started_at, type: String

              # rubocop:disable Layout/LineLength
              internal :started_at,
                       type: String,
                       check_format: {
                         is: :time,
                         pattern: /^(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(\.[0-9]+)?(Z|[+-](?:2[0-3]|[01][0-9]):[0-5][0-9])?$/
                       }
              # rubocop:enable Layout/LineLength

              output :started_at, type: ::Time

              make :assign_internal

              make :assign_output

              private

              def assign_internal
                internals.started_at = inputs.started_at
              end

              def assign_output
                outputs.started_at = ::Time.parse(internals.started_at)
              end
            end
          end
        end
      end
    end
  end
end
