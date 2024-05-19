# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Email
        module Optional
          class Example3 < ApplicationService::Base
            input :email, type: String, required: false

            output :email, type: [String, NilClass], format: :email

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
