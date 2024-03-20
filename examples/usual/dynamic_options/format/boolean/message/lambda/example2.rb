# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Boolean
        module Message
          module Lambda
            class Example2 < ApplicationService::Base
              input :boolean, type: String

              internal :boolean,
                       type: String,
                       check_format: {
                         is: :boolean,
                         message: lambda do |internal:, value:, option_value:, **|
                           "Value `#{value}` does not match the format of `#{option_value}` in `#{internal.name}`"
                         end
                       }

              output :boolean, type: String

              make :assign_internal

              make :assign_output

              private

              def assign_internal
                internals.boolean = inputs.boolean
              end

              def assign_output
                outputs.boolean = internals.boolean
              end
            end
          end
        end
      end
    end
  end
end
