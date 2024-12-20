# frozen_string_literal: true

module Usual
  module Stage
    class Example12Transaction
      def self.transaction
        yield
      end
    end

    class Example12 < ApplicationService::Base
      output :number, type: Integer

      make :assign_number_4

      stage do
        make :assign_number_5
        make :assign_number_6
        make :assign_number_7

        wrap_in ->(methods:, context:) { context.transaction! { methods.call } }
        rollback :method_for_rollback
      end

      make :assign_number_8

      def assign_number_4
        outputs.number = 4
      end

      def assign_number_5
        outputs.number = 5
      end

      def assign_number_6
        # outputs.number = 6

        raise "bad number"
      end

      def assign_number_7
        outputs.number = 7
      end

      def assign_number_8
        outputs.number = 8
      end

      def transaction!(&block)
        Example12Transaction.transaction(&block)
      end

      def method_for_rollback(e) # rubocop:disable Naming/MethodParameterName
        fail!(message: "rollback with #{e.message}")
      end
    end
  end
end
