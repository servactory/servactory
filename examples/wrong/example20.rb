# frozen_string_literal: true

module Wrong
  class Example20 < ApplicationService::Base
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
