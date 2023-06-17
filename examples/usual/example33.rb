# frozen_string_literal: true

module Usual
  class Example33 < ApplicationService::Base
    output :number, type: Integer

    private

    def call
      outputs.number = 7
    end
  end
end
