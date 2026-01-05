# frozen_string_literal: true

module Wrong
  module TestKit
    module Rspec
      module Matchers
        class FailureService < ApplicationService::Base
          input :should_fail, type: [TrueClass, FalseClass]

          def call
            return unless inputs.should_fail

            fail!(:validation_error, message: "Expected failure", meta: { code: 422 })
          end
        end
      end
    end
  end
end
