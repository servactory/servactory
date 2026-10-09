# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked or passed through) with required and optional inputs
        class Example12Child < ApplicationService::Base
          input :query, type: String
          input :limit, type: Integer, required: false, default: 3

          output :matches, type: Array

          make :search

          private

          def search
            outputs.matches = Array.new(inputs.limit) { |index| "#{inputs.query}-#{index}" }
          end
        end

        # Parent service (tested, calls child without the optional input)
        class Example12 < ApplicationService::Base
          input :query, type: String

          output :matches_count, type: Integer

          make :search

          private

          def search
            result = Example12Child.call(query: inputs.query)

            fail!(message: result.error.message) if result.failure?

            outputs.matches_count = result.matches.size
          end
        end
      end
    end
  end
end
