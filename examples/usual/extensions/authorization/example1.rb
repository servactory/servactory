# frozen_string_literal: true

module Usual
  module Extensions
    module Authorization
      class Example1 < ApplicationService::Base
        input :user_id, type: Integer
        input :current_user_id, type: Integer

        output :message, type: String

        authorize_with :can_access_resource?

        make :assign_message

        private

        def can_access_resource?
          inputs.current_user_id == inputs.user_id
        end

        def assign_message
          outputs.message = "Access granted for user #{inputs.user_id}"
        end
      end
    end
  end
end
