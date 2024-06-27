# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Password
        module Optional
          class Example2 < ApplicationService::Base
            input :password, type: String, required: false

            internal :password, type: [String, NilClass], check_format: :password

            output :password, type: [String, NilClass]

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
