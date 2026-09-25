# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked or passed through) without inputs
        class Example17Child < ApplicationService::Base
          output :token, type: String

          make :generate_token

          private

          def generate_token
            outputs.token = "token"
          end
        end

        # Parent service (tested, calls child with call! without arguments)
        class Example17 < ApplicationService::Base
          output :authorization, type: String

          make :authorize

          private

          def authorize
            outputs.authorization = "Bearer #{Example17Child.call!.token}"
          end
        end
      end
    end
  end
end
