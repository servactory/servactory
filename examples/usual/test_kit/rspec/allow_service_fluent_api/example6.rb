# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked) for sequential returns ending with failure
        class Example6Child < ApplicationService::Base
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

        # Parent service (tested, calls child with retry logic that may fail)
        class Example6 < ApplicationService::Base
          input :max_attempts, type: Integer

          output :final_status, type: Symbol
          output :total_attempts, type: Integer
          output :error_message, type: [String, NilClass]

          make :process_with_retries

          private

          def process_with_retries # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
            attempt = 1
            result = nil
            error = nil

            while attempt <= inputs.max_attempts
              result = Example6Child.call(attempt:)

              if result.failure?
                error = result.error
                break
              end

              break if result.success? && result.status == :completed

              attempt += 1
            end

            outputs.final_status = error ? :error : (result&.status || :unknown)
            outputs.total_attempts = attempt
            outputs.error_message = error&.message
          end
        end
      end
    end
  end
end
