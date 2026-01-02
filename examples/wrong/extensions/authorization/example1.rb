# frozen_string_literal: true

module Wrong
  module Extensions
    module Authorization
      class Example1 < ApplicationService::Base
        input :user_role, type: String

        output :message, type: String

        authorize_with :user_authorized?

        make :assign_message

        private

        def user_authorized?
          inputs.user_role == "admin"
        end

        def assign_message
          outputs.message = "Access granted for #{inputs.user_role}"
        end
      end
    end
  end
end
