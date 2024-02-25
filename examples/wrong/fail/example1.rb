# frozen_string_literal: true

module Wrong
  module Fail
    class Example1 < ApplicationService::Base
      make :smth

      private

      def smth
        # ...
      end

      def fail_input!
        # ...
      end

      def fail_internal!
        # ...
      end

      def fail_output!
        # ...
      end

      def fail!
        # ...
      end

      def fail_result!
        # ...
      end
    end
  end
end
