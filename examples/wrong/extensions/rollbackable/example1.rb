# frozen_string_literal: true

module Wrong
  module Extensions
    module Rollbackable
      class Example1 < ApplicationService::Base
        LikeARollbackTracker = Class.new do
          class << self
            attr_accessor :rollback_called

            def reset!
              self.rollback_called = false
            end

            def mark_rollback!
              self.rollback_called = true
            end
          end
        end

        input :value, type: Integer

        output :total, type: Integer

        on_rollback :cleanup_resources

        make :process_value
        make :fail_operation

        private

        def process_value
          outputs.total = inputs.value + 100
        end

        def fail_operation
          fail!(:operation_failed, message: "Something went wrong")
        end

        def cleanup_resources
          LikeARollbackTracker.mark_rollback!
        end
      end
    end
  end
end
