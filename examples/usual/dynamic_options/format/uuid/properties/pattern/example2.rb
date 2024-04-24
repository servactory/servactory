# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Uuid
        module Properties
          module Pattern
            class Example2 < ApplicationService::Base
              input :uuid, type: String

              internal :uuid,
                       type: String,
                       check_format: {
                         is: :uuid,
                         pattern: nil # This will disable the value checking based on the pattern
                       }

              output :uuid, type: String

              make :assign_internal

              make :assign_output

              private

              def assign_internal
                internals.uuid = inputs.uuid
              end

              def assign_output
                outputs.uuid = internals.uuid
              end
            end
          end
        end
      end
    end
  end
end
