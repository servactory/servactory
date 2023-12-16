# frozen_string_literal: true

module Wrong
  module Basic
    class Example10 < ApplicationService::Base
      output :value, type: String

      def call; end
    end
  end
end
