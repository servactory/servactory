# frozen_string_literal: true

module Wrong
  module Fail
    class Example3 < ApplicationService::Base
      make :smth

      private

      def smth
        # ...
      end

      def fail_internal!
        # ...
      end
    end
  end
end
