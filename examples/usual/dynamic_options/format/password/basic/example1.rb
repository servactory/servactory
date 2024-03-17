# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Password
        module Basic
          class Example1 < ApplicationService::Base
            input :password, type: String, format: :password

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
