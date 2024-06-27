# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Uuid
        module Optional
          class Example3 < ApplicationService::Base
            input :service_id, type: String, required: false

            output :service_id, type: [String, NilClass], format: :uuid

            make :assign_output

            private

            def assign_output
              outputs.service_id = inputs.service_id
            end
          end
        end
      end
    end
  end
end
