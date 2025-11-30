# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Internal
        class Example3 < ApplicationService::Base
          internal :internal, type: String

          output :result, type: String

          make :assign_result

          private

          def assign_result
            outputs.result = internals.internal
          end
        end
      end
    end
  end
end
