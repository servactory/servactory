# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked) for call! testing
        class Example3Child < ApplicationService::Base
          input :user_id, type: Integer

          output :user_name, type: String
          output :user_email, type: String

          make :fetch_user

          private

          def fetch_user
            outputs.user_name = "User #{inputs.user_id}"
            outputs.user_email = "user#{inputs.user_id}@example.com"
          end
        end

        # Parent service (tested, uses call! to propagate exceptions)
        class Example3 < ApplicationService::Base
          input :user_id, type: Integer

          output :greeting, type: String

          make :build_greeting

          private

          def build_greeting
            result = Example3Child.call!(user_id: inputs.user_id)

            outputs.greeting = "Hello, #{result.user_name}!"
          end
        end
      end
    end
  end
end
