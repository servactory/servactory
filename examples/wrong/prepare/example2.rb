# frozen_string_literal: true

module Wrong
  module Prepare
    class Example2 < ApplicationService::Base
      input :invoice_numbers,
            type: String,
            must: {
              be_6_characters: {
                is: ->(**) {}
              }
            },
            prepare: ->(value:) { value }
    end
  end
end
