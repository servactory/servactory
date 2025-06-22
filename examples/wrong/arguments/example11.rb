# frozen_string_literal: true

module Wrong
  module Arguments
    class Example11 < ApplicationService::Base
      input :output, type: String

      make :smth

      private

      def smth
        # ...
      end
    end
  end
end 