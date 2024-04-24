# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Uuid
        module Message
          module Static
            class Example3 < ApplicationService::Base
              input :service_id, type: String

              output :service_id,
                     type: String,
                     format: {
                       is: :uuid,
                       message: "Invalid date format"
                     }

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
end
