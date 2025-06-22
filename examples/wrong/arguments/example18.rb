# frozen_string_literal: true

module Wrong
  module Arguments
    class Example18 < ApplicationService::Base
      input :failure, type: String

      make :smth

      private

      def smth
        # ...
      end
    end
  end
end
