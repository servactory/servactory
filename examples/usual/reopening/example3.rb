# frozen_string_literal: true

module Usual
  module Reopening
    class Example3Base < ApplicationService::Base
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

    class Example3 < Example3Base
      input :middle_name, type: String, required: false
    end

    Example3Base.call(first_name: "john")
    Example3.call(first_name: "john")

    class Example3
      input :last_name, type: String

      internal :prepared_full_name, type: String

      output :full_name, type: String

      make :prepare_full_name

      stage do
        make :assign_full_name
      end

      private

      def prepare_full_name
        internals.prepared_full_name = [
          internals.prepared_first_name,
          inputs.middle_name,
          inputs.last_name.capitalize
        ].compact.join(" ")
      end

      def assign_full_name
        outputs.full_name = internals.prepared_full_name
      end
    end
  end
end
