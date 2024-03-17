# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Email
        module Is
          class Example3 < ApplicationService::Base
            input :email, type: String

            output :email, type: String, format: { is: :email }

            make :assign_output

            private

            def assign_output
              outputs.email = inputs.email
            end
          end
        end
      end
    end
  end
end
