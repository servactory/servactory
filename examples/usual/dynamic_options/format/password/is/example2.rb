# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Password
        module Is
          class Example2 < ApplicationService::Base
            input :password, type: String

            internal :password, type: String, check_format: { is: :password }

            output :password, type: String

            make :assign_internal

            make :assign_output

            private

            def assign_internal
              internals.password = inputs.password
            end

            def assign_output
              outputs.password = internals.password
            end
          end
        end
      end
    end
  end
end
