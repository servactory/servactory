# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Inclusion
      class Example1 < ApplicationService::Base
        input :event_name, type: String, inclusion: nil

        make :perform

        private

        def perform
          # ...
        end
      end
    end
  end
end
