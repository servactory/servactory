# frozen_string_literal: true

module Wrong
  class Example19 < ApplicationService::Base
    input :event_name,
          type: String,
          inclusion: %w[created rejected approved],
          prepare: ->(value:) { value }
  end
end
