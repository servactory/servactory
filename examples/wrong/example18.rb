# frozen_string_literal: true

module Wrong
  class Example18 < ApplicationService::Base
    input :ids,
          type: String,
          array: true,
          prepare: ->(value:) { value }

    def call; end
  end
end
