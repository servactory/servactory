# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Uuid
        module Optional
          class Example2 < ApplicationService::Base
            input :service_id, type: String, required: false

            internal :service_id, type: [String, NilClass], check_format: :uuid

            output :service_id, type: [String, NilClass]

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
