# frozen_string_literal: true

module Usual
  module Reopening
    class Example2 < ApplicationService::Base
      input :first_name, type: String

      internal :prepared_first_name, type: String

      output :greeting, type: String

      make :prepare_first_name
      make :assign_greeting

      private

      def prepare_first_name
        internals.prepared_first_name = inputs.first_name.capitalize
      end

      def assign_greeting
        outputs.greeting = "Hello, #{internals.prepared_first_name}!"
      end
    end

    Example2.call(first_name: "john")

    class Example2
      input :last_name, type: String

      internal :prepared_full_name, type: String

      output :full_name, type: String

      make :prepare_full_name
      make :assign_full_name

      private

      def prepare_full_name
        internals.prepared_full_name = "#{internals.prepared_first_name} #{inputs.last_name.capitalize}"
      end

      def assign_full_name
        outputs.full_name = internals.prepared_full_name
      end
    end
  end
end
