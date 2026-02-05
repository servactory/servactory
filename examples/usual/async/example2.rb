# frozen_string_literal: true

module Usual
  module Async
    class Example2 < ApplicationService::Base
      input :first_name, type: String
      input :last_name, type: String

      internal :full_name, type: String

      output :greeting, type: String

      make :build_full_name
      make :build_greeting

      private

      def build_full_name
        sleep 1

        internals.full_name = "#{inputs.first_name} #{inputs.last_name}"
      end

      def build_greeting
        sleep 1

        outputs.greeting = "Hello, #{internals.full_name}!"
      end
    end
  end
end
