# frozen_string_literal: true

module Wrong
  module Extensions
    module Transactional
      class Example1 < ApplicationService::Base
        LikeAnActiveRecordTransaction = Class.new do
          class << self
            attr_accessor :transaction_started, :transaction_committed, :transaction_rolled_back

            def reset!
              self.transaction_started = false
              self.transaction_committed = false
              self.transaction_rolled_back = false
            end

            def transaction
              self.transaction_started = true

              yield

              self.transaction_committed = true
            rescue StandardError
              self.transaction_rolled_back = true

              raise
            end
          end
        end

        input :value, type: Integer
        input :should_fail, type: [TrueClass, FalseClass], default: false

        output :result, type: Integer

        transactional! transaction_class: LikeAnActiveRecordTransaction

        make :process_value

        private

        def process_value
          fail!(:processing_error, message: "Processing failed") if inputs.should_fail

          outputs.result = inputs.value * 10
        end
      end
    end
  end
end
