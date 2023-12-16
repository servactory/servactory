# frozen_string_literal: true

module Wrong
  class Example7 < ApplicationService::Base
    input :event_name, type: String, default: "created"
  end
end
