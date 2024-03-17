# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Password
        module Message
          module Static
            class Example1 < ApplicationService::Base
              input :password,
                    type: String,
                    format: {
                      is: :password,
                      message: "Invalid date format"
                    }

              output :password, type: String

              make :assign_output

              private

              def assign_output
                outputs.password = inputs.password
              end
            end
          end
        end
      end
    end
  end
end
