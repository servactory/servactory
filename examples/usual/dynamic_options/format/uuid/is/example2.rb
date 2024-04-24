# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Uuid
        module Is
          class Example2 < ApplicationService::Base
            input :service_id, type: String

            internal :service_id, type: String, check_format: { is: :uuid }

            output :service_id, type: String

            make :assign_internal

            make :assign_output

            private

            def assign_internal
              internals.service_id = inputs.service_id
            end

            def assign_output
              outputs.service_id = internals.service_id
            end
          end
        end
      end
    end
  end
end
