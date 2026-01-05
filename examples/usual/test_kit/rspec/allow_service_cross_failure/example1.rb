# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceCrossFailure
        # Child service uses AlternativeService::Base with AlternativeService::Exceptions::Failure.
        # This simulates a service from a different gem/library with its own failure class.
        class Example1Child < AlternativeService::Base
          make :method_fail!

          private

          def method_fail!
            fail!(message: "Alternative service error", meta: { source: :alternative })
          end
        end

        # Parent service uses ApplicationService::Base with ApplicationService::Exceptions::Failure.
        # This simulates calling a service from a different gem/library.
        class Example1 < ApplicationService::Base
          make :child_call

          private

          def child_call
            service_result = Example1Child.call

            fail_result!(service_result) if service_result.failure?
          end
        end
      end
    end
  end
end
