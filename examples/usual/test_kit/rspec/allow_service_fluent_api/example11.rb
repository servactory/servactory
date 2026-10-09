# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module AllowServiceFluentApi
        # Child service (mocked) with only optional inputs
        class Example11Child < ApplicationService::Base
          input :locale, type: String, required: false
          input :limit, type: Integer, required: false, default: 3

          output :entries, type: Array

          make :fetch_entries

          private

          def fetch_entries
            outputs.entries = Array.new(inputs.limit) { |index| "#{inputs.locale || 'en'}-#{index}" }
          end
        end

        # Parent service (tested, calls child without inputs)
        class Example11 < ApplicationService::Base
          output :entries_count, type: Integer

          make :count_entries

          private

          def count_entries
            result = Example11Child.call

            fail!(message: result.error.message) if result.failure?

            outputs.entries_count = result.entries.size
          end
        end
      end
    end
  end
end
