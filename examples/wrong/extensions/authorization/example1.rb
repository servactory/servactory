# frozen_string_literal: true

module Wrong
  module Extensions
    module Authorization
      class Example1 < ApplicationService::Base
        LikeASideEffectTracker = Class.new do
          class << self
            attr_accessor :executed

            def reset!
              self.executed = false
            end

            def mark_executed!
              self.executed = true
            end
          end
        end

        input :user_role, type: String

        output :message, type: String

        authorize_with :user_authorized?

        make :track_execution
        make :assign_message

        private

        def user_authorized?(incoming_arguments)
          incoming_arguments[:user_role] == "admin"
        end

        def track_execution
          LikeASideEffectTracker.mark_executed!
        end

        def assign_message
          outputs.message = "Access granted for #{inputs.user_role}"
        end
      end
    end
  end
end
