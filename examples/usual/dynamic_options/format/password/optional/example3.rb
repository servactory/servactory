# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Password
        module Optional
          class Example3 < ApplicationService::Base
            input :password, type: String, required: false

            output :password, type: [String, NilClass], format: :password

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
