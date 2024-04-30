# frozen_string_literal: true

module Usual
  module ValidationMode
    class Example1 < ApplicationService::Base
      configuration do
        validation_mode :bang_without_throwing_exception_for_attributes
      end

      input :number, type: Integer

      internal :number, type: Integer

      make :assign_internal

      private

      def assign_internal
        internals.number = inputs.number.to_s
      end
    end
  end
end
