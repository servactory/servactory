# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Boolean
        module Message
          module Static
            class Example1 < ApplicationService::Base
              input :boolean,
                    type: String,
                    format: {
                      is: :boolean,
                      message: "Invalid boolean format"
                    }

              output :boolean, type: String

              make :assign_output

              private

              def assign_output
                outputs.boolean = inputs.boolean
              end
            end
          end
        end
      end
    end
  end
end
