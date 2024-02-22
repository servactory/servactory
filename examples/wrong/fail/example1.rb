# frozen_string_literal: true

module Wrong
  module Fail
    class Example1 < ApplicationService::Base
      make :smth

      private

      def smth
        # ...
      end

      def fail!
        # ...
      end
    end
  end
end
