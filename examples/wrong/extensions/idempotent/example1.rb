# frozen_string_literal: true

module Wrong
  module Extensions
    module Idempotent
      class Example1 < ApplicationService::Base
        LikeAnIdempotencyStore = Class.new do
          class << self
            attr_accessor :store, :execution_count

            def reset!
              self.store = {}
              self.execution_count = 0
            end

            def get(key)
              store[key]
            end

            def set(key, value)
              store[key] = value
            end

            def increment_execution!
              self.execution_count ||= 0
              self.execution_count += 1
            end
          end
        end

        input :request_id, type: String
        input :amount, type: Integer

        output :value, type: Integer

        idempotent! by: :request_id, store: LikeAnIdempotencyStore

        make :process_amount
        make :fail_operation

        private

        def process_amount
          LikeAnIdempotencyStore.increment_execution!

          outputs.value = inputs.amount * 5
        end

        def fail_operation
          fail!(:processing_failed, message: "Failed to process amount")
        end
      end
    end
  end
end
