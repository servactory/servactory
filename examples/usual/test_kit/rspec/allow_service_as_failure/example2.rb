# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceAsFailure
        class Example2Child < ApplicationService::Base
          make :method_fail!

          private

          def method_fail!
            fail!(message: "Some error", meta: { some: :data })
          end
        end

        class Example2 < ApplicationService::Base
          internal :child_result, type: Servactory::Result

          make :child_result
          make :process_child_result!

          private

          def child_result
            internals.child_result = Example2Child.call
          end

          def process_child_result!
            internals.child_result
                     .on_success { handle_success! }
                     .on_failure { |exception:, **| handle_failure!(exception) }
          end

          def handle_success!
            "do something"
          end

          def handle_failure!(exception)
            fail!(message: exception.message, meta: exception.meta)
          end
        end
      end
    end
  end
end
