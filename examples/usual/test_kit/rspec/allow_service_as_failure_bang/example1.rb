# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceAsFailureBang
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
            Example1Child.call!
          end
        end
      end
    end
  end
end
