# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceAsSuccess
        class Example2Child < ApplicationService::Base
          make :method_fail!

          private

          def method_fail!
            fail!(message: "Some error", meta: { some: :data })
          end
        end

        class Example2 < ApplicationService::Base
          output :child_result, type: Servactory::Result

          make :child_fail!

          private

          def child_fail!
            outputs.child_result = Example2Child.call

            fail_result!(outputs.child_result) if outputs.child_result.failure?
          end
        end
      end
    end
  end
end
