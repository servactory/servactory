# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked or passed through)
        class Example10Child < ApplicationService::Base
          input :data, type: String

          output :result, type: String

          make :process

          private

          def process
            outputs.result = "processed:#{inputs.data}"
          end
        end

        # Parent service (tested, calls child)
        class Example10 < ApplicationService::Base
          input :data, type: String

          output :result, type: String

          make :delegate_to_child

          private

          def delegate_to_child
            child_result = Example10Child.call(data: inputs.data)

            fail!(message: child_result.error.message) if child_result.failure?

            outputs.result = child_result.result
          end
        end
      end
    end
  end
end
