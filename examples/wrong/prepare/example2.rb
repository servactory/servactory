# frozen_string_literal: true

module Wrong
  module Prepare
    class Example2 < ApplicationService::Base
      input :ids,
            type: Array,
            consists_of: String,
            prepare: ->(value:) { value }

      def call; end
    end
  end
end
