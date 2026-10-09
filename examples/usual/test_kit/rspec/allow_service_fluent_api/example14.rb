# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (wrapped) with required and optional inputs
        class Example14Child < ApplicationService::Base
          input :text, type: String
          input :suffix, type: String, required: false, default: "!"

          output :result, type: String

          make :decorate

          private

          def decorate
            outputs.result = "#{inputs.text}#{inputs.suffix}"
          end
        end

        # Parent service (tested, calls child with a positional Hash)
        class Example14 < ApplicationService::Base
          input :text, type: String

          output :result, type: String

          make :decorate

          private

          def decorate
            child_result = Example14Child.call!({ text: inputs.text })

            outputs.result = child_result.result
          end
        end
      end
    end
  end
end
