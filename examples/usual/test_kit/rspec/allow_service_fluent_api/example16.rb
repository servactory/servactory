# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked or passed through) with only optional inputs
        class Example16Child < ApplicationService::Base
          input :locale, type: String, required: false, default: "en"

          output :greeting, type: String

          make :greet

          private

          def greet
            outputs.greeting = "hello-#{inputs.locale}"
          end
        end

        # Parent service (tested, calls child without arguments)
        class Example16 < ApplicationService::Base
          output :greeting, type: String

          make :greet

          private

          def greet
            result = Example16Child.call

            fail!(message: result.error.message) if result.failure?

            outputs.greeting = result.greeting.upcase
          end
        end
      end
    end
  end
end
