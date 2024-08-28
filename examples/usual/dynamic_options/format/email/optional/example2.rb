# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Email
        module Optional
          class Example2 < ApplicationService::Base
            input :email, type: String, required: false

            internal :email, type: [String, NilClass], check_format: :email

            output :email, type: [String, NilClass]

            make :assign_internal

            make :assign_output

            private

            def assign_internal
              internals.email = inputs.email
            end

            def assign_output
              outputs.email = internals.email.present? ? "No Reply <#{internals.email}>" : nil
            end
          end
        end
      end
    end
  end
end
