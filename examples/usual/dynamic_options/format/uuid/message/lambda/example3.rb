# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Uuid
        module Message
          module Lambda
            class Example3 < ApplicationService::Base
              input :service_id, type: String

              output :service_id,
                     type: String,
                     format: {
                       is: :uuid,
                       message: lambda do |output:, value:, option_value:, **|
                         "Value `#{value}` does not match the format of `#{option_value}` in `#{output.name}`"
                       end
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
