# frozen_string_literal: true

module Wrong
  module Success
    class Example1 < ApplicationService::Base
      make :smth

      private

      def smth
        success!
      end

      def success!
        # ...
      end
    end
  end
end
