# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Uuid
        module Properties
          module Pattern
            class Example1 < ApplicationService::Base
              input :uuid,
                    type: String,
                    format: {
                      is: :uuid,
                      pattern: nil # This will disable the value checking based on the pattern
                    }

              output :uuid, type: String

              make :assign_output

              private

              def assign_output
                outputs.uuid = inputs.uuid
              end
            end
          end
        end
      end
    end
  end
end
