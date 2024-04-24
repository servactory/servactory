# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Uuid
        module Properties
          module Pattern
            class Example3 < ApplicationService::Base
              input :service_id, type: String

              output :service_id,
                     type: String,
                     format: {
                       is: :uuid,
                       pattern: nil # This will disable the value checking based on the pattern
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
