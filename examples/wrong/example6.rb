# frozen_string_literal: true

module Wrong
  class Example6 < ApplicationService::Base
    input :event_name,
          type: Array,
          of: String,
          inclusion: %w[created rejected approved]
  end
end
