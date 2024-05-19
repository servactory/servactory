# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Format
      module Email
        module Optional
          class Example1 < ApplicationService::Base
            input :email, type: String, format: :email, required: false

            output :email, type: [String, NilClass]

            make :assign_output

            private

            def assign_output
              outputs.email = inputs.email.present? ? "No Reply <#{inputs.email}>" : nil
            end
          end
        end
      end
    end
  end
end
