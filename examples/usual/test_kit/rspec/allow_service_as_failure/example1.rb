# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceAsFailure
        class Example1Child < ApplicationService::Base
          make :method_fail!

          private

          def method_fail!
            fail!(message: "Some error", meta: { some: :data })
          end
        end

        class Example1 < ApplicationService::Base
          make :child_fail!

          private

          def child_fail!
            service_result = Example1Child.call

            fail_result!(service_result) if service_result.failure?
          end
        end
      end
    end
  end
end
