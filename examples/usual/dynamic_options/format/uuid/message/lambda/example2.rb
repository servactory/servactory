# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Uuid
        module Message
          module Lambda
            class Example2 < ApplicationService::Base
              input :service_id, type: String

              internal :service_id,
                       type: String,
                       check_format: {
                         is: :uuid,
                         message: lambda do |internal:, value:, option_value:, **|
                           "Value `#{value}` does not match the format of `#{option_value}` in `#{internal.name}`"
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
