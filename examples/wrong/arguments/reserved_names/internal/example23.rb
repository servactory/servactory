# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Internal
        class Example23 < ApplicationService::Base
          internal :outputs, type: String

          output :result, type: String

          make :assign_result

          private

          def assign_result
            outputs.result = internals.outputs
          end
        end
      end
    end
  end
end
