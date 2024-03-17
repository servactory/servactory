# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Email
        module Message
          module Static
            class Example1 < ApplicationService::Base
              input :email,
                    type: String,
                    format: {
                      is: :email,
                      message: "Invalid email format"
                    }

              output :email, type: String

              make :assign_output

              private

              def assign_output
                outputs.email = "No Reply <#{inputs.email}>"
              end
            end
          end
        end
      end
    end
  end
end
