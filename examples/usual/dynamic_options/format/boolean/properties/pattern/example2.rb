# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Boolean
        module Properties
          module Pattern
            class Example2 < ApplicationService::Base
              input :boolean, type: String

              internal :boolean,
                       type: String,
                       check_format: {
                         is: :boolean,
                         pattern: nil # This will disable the value checking based on the pattern
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
