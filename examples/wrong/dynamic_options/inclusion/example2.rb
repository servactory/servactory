# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Inclusion
      class Example2 < ApplicationService::Base
        input :event_name, type: String, inclusion: { in: nil }

        make :perform

        private

        def perform
          # ...
        end
      end
    end
  end
end
