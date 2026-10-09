# frozen_string_literal: true

require "datory"

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked or passed through) called with a Datory object
        class Example21Child < ApplicationService::Base
          class Event < ::Datory::Base
            uuid! :id
            string! :title
          end

          input :id, type: String
          input :title, type: String

          output :summary, type: String

          make :summarize

          private

          def summarize
            outputs.summary = "#{inputs.title} (#{inputs.id})"
          end
        end

        # Parent service (tested, calls child with a Datory object)
        class Example21 < ApplicationService::Base
          input :id, type: String
          input :title, type: String

          output :summary, type: String

          make :summarize

          private

          def summarize
            event = Example21Child::Event.deserialize(id: inputs.id, title: inputs.title)

            result = Example21Child.call(event)

            fail!(message: result.error.message) if result.failure?

            outputs.summary = result.summary
          end
        end
      end
    end
  end
end
