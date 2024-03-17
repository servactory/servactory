# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Password
        module Is
          class Example3 < ApplicationService::Base
            input :password, type: String

            output :password, type: String, format: { is: :password }

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
