# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceAsFailureBang
        # Child service (mocked) with inputs for testing with: parameter
        class Example2Child < ApplicationService::Base
          input :user_id, type: Integer

          output :user_name, type: String

          make :fetch_user

          private

          def fetch_user
            fail!(type: :user_not_found, message: "User not found", meta: { user_id: inputs.user_id })
          end
        end

        # Parent service (tested, calls child with call!)
        class Example2 < ApplicationService::Base
          input :user_id, type: Integer

          output :greeting, type: String

          make :greet_user

          private

          def greet_user
            result = Example2Child.call!(user_id: inputs.user_id)

            outputs.greeting = "Hello, #{result.user_name}!"
          end
        end
      end
    end
  end
end
