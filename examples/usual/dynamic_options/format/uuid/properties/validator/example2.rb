# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Uuid
        module Properties
          module Validator
            class Example2 < ApplicationService::Base
              input :service_id, type: String

              internal :service_id,
                       type: String,
                       check_format: {
                         is: :uuid,
                         pattern: nil, # This will disable the value checking based on the pattern
                         validator: lambda do |value:|
                           value.size >= 9
                         end
                       }

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
end
