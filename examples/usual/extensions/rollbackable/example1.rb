# frozen_string_literal: true

module Usual
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

        private

        def process_value
          outputs.total = inputs.value + 100
        end

        def cleanup_resources
          LikeARollbackTracker.mark_rollback!
        end
      end
    end
  end
end
