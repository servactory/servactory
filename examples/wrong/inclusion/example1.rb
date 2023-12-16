# frozen_string_literal: true

module Wrong
  module Inclusion
    class Example1 < ApplicationService::Base
      input :event_name,
            type: Array,
            consists_of: String,
            inclusion: %w[created rejected approved]
    end
  end
end
