# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Uuid
        module Message
          module Static
            class Example1 < ApplicationService::Base
              input :uuid,
                    type: String,
                    format: {
                      is: :uuid,
                      message: "Invalid date format"
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
