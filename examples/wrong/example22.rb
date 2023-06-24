# frozen_string_literal: true

module Wrong
  class Example22 < ApplicationService::Base
    output :value, type: String

    def call; end
  end
end
