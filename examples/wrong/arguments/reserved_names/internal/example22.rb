# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Internal
        class Example22 < ApplicationService::Base
          internal :output, type: String

          output :result, type: String

          make :assign_result

          private

          def assign_result
            outputs.result = internals.output
          end
        end
      end
    end
  end
end
