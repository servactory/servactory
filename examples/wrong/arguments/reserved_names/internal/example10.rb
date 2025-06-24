# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Internal
        class Example10 < ApplicationService::Base
          internal :inputs, type: String

          output :result, type: String

          make :assign_result

          private

          def assign_result
            outputs.result = internals.inputs
          end
        end
      end
    end
  end
end
