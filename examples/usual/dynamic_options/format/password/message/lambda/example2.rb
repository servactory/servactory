# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Password
        module Message
          module Lambda
            class Example2 < ApplicationService::Base
              input :password, type: String

              internal :password,
                       type: String,
                       check_format: {
                         is: :password,
                         message: lambda do |internal:, value:, option_value:, **|
                           "Value `#{value}` does not match the format of `#{option_value}` in `#{internal.name}`"
                         end
                       }

              output :password, type: String

              make :assign_internal

              make :assign_output

              private

              def assign_internal
                internals.password = inputs.password
              end

              def assign_output
                outputs.password = internals.password
              end
            end
          end
        end
      end
    end
  end
end
