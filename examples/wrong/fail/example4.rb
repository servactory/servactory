# frozen_string_literal: true

module Wrong
  module Fail
    class Example4 < ApplicationService::Base
      make :smth

      private

      def smth
        # ...
      end

      def fail_output!
        # ...
      end
    end
  end
end
