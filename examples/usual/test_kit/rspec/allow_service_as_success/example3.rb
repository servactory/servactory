# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceAsSuccess
        class Example3Child < ApplicationService::Base
          input :number, type: Integer

          make :method_fail!

          private

          def method_fail!
            fail!(message: "Some error", meta: { some: :data })
          end
        end

        class Example3 < ApplicationService::Base
          output :child_result, type: Servactory::Result

          make :child_fail!

          private

          def child_fail!
            outputs.child_result = Example3Child.call(number: 7)

            fail_result!(outputs.child_result) if outputs.child_result.failure?
          end
        end
      end
    end
  end
end
