# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (passed through) called with call!
        class Example15Child < ApplicationService::Base
          input :id, type: Integer
          input :prefix, type: String, required: false, default: "item"

          output :label, type: String

          make :build_label

          private

          def build_label
            outputs.label = "#{inputs.prefix}-#{inputs.id}"
          end
        end

        # Parent service (tested, calls child with call! without the optional input)
        class Example15 < ApplicationService::Base
          input :id, type: Integer

          output :label, type: String

          make :fetch_label

          private

          def fetch_label
            outputs.label = Example15Child.call!(id: inputs.id).label
          end
        end
      end
    end
  end
end
