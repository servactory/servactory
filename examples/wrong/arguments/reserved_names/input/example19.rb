# frozen_string_literal: true

module Wrong
  module Arguments
    class Example19 < ApplicationService::Base
      input :success, type: String

      make :smth

      private

      def smth
        # ...
      end
    end
  end
end
