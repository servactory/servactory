# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (wrapped) with only optional inputs
        class Example20Child < ApplicationService::Base
          input :separator, type: String, required: false, default: ", "

          output :text, type: String

          make :join_words

          private

          def join_words
            outputs.text = %w[one two].join(inputs.separator)
          end
        end

        # Parent service (tested, calls child with a positional Hash that may be empty)
        class Example20 < ApplicationService::Base
          input :separator, type: String, required: false

          output :text, type: String

          make :build_text

          private

          def build_text
            options = inputs.separator.nil? ? {} : { separator: inputs.separator }

            outputs.text = Example20Child.call!(options).text
          end
        end
      end
    end
  end
end
