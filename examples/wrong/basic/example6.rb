# frozen_string_literal: true

module Wrong
  module Basic
    class Example6 < ApplicationService::Base
      input :event_name, type: String, default: "created"
    end
  end
end
