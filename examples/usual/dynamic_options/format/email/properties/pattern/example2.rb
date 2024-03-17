# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Email
        module Properties
          module Pattern
            class Example2 < ApplicationService::Base
              input :email, type: String

              internal :email,
                       type: String,
                       check_format: {
                         is: :email,
                         pattern: nil # This will disable the value checking based on the pattern
                       }

              output :email, type: String

              make :assign_internal

              make :assign_output

              private

              def assign_internal
                internals.email = inputs.email
              end

              def assign_output
                outputs.email = "No Reply <#{internals.email}>"
              end
            end
          end
        end
      end
    end
  end
end
