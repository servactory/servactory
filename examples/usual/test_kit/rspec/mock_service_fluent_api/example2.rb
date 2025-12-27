# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module MockServiceFluentApi
        # Service for testing sequential returns
        class Example2Child < ApplicationService::Base
          output :attempt, type: Integer

          make :process

          private

          def process
            outputs.attempt = 1
          end
        end

        # Parent service that calls Example2Child multiple times
        class Example2 < ApplicationService::Base
          output :results, type: Array

          make :call_multiple_times

          private

          def call_multiple_times
            outputs.results = []
            3.times do
              result = Example2Child.call
              outputs.results << result.attempt if result.success?
            end
          end
        end
      end
    end
  end
end
