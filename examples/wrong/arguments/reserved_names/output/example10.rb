# frozen_string_literal: true

module Wrong
  module Arguments
    module ReservedNames
      module Output
        class Example10 < ApplicationService::Base
          output :info, type: String

          make :assign_info

          private

          def assign_info
            outputs.info = "test"
          end
        end
      end
    end
  end
end
