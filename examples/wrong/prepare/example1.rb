# frozen_string_literal: true

module Wrong
  module Prepare
    class Example1 < ApplicationService::Base
      input :event_name,
            type: String,
            inclusion: %w[created rejected approved],
            prepare: ->(value:) { value }
    end
  end
end
