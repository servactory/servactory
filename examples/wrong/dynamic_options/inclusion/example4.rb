# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Inclusion
      class Example4 < ApplicationService::Base
        input :event_name, type: String

        internal :event_type, type: String, inclusion: { in: nil }

        make :assign_event_type

        private

        def assign_event_type
          internals.event_type = inputs.event_name
        end
      end
    end
  end
end
