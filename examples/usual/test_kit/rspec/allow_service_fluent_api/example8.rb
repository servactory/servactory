# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked) with multiple outputs
        class Example8Child < ApplicationService::Base
          input :user_id, type: Integer

          output :full_name, type: String
          output :email, type: String
          output :is_active, type: [TrueClass, FalseClass]

          make :fetch_user

          private

          def fetch_user
            outputs.full_name = "User #{inputs.user_id}"
            outputs.email = "user#{inputs.user_id}@example.com"
            outputs.is_active = true
          end
        end

        # Parent service (tested, calls child and uses all outputs)
        class Example8 < ApplicationService::Base
          input :user_id, type: Integer

          output :display_name, type: String
          output :contact_email, type: String
          output :account_status, type: Symbol

          make :load_user_info

          private

          def load_user_info
            result = Example8Child.call!(user_id: inputs.user_id)

            outputs.display_name = result.full_name
            outputs.contact_email = result.email
            outputs.account_status = result.is_active ? :active : :inactive
          end
        end
      end
    end
  end
end
