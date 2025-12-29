# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked) for sequential returns
        class Example2Child < ApplicationService::Base
          input :attempt, type: Integer

          output :status, type: Symbol
          output :attempt_number, type: Integer

          make :process

          private

          def process
            outputs.status = :processing
            outputs.attempt_number = inputs.attempt
          end
        end

        # Parent service (tested, calls child multiple times)
        class Example2 < ApplicationService::Base
          input :max_attempts, type: Integer

          output :final_status, type: Symbol
          output :total_attempts, type: Integer

          make :process_with_retries

          private

          def process_with_retries
            attempt = 1
            result = nil

            while attempt <= inputs.max_attempts
              result = Example2Child.call(attempt:)
              break if result.success? && result.status == :completed

              attempt += 1
            end

            outputs.final_status = result&.status || :unknown
            outputs.total_attempts = attempt
          end
        end
      end
    end
  end
end
