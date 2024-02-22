# frozen_string_literal: true

module Wrong
  module Fail
    class Example2 < ApplicationService::Base
      make :smth

      private

      def smth
        # ...
      end

      def fail_input!
        # ...
      end
    end
  end
end
