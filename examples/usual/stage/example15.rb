# frozen_string_literal: true

module Usual
  module Stage
    class Example15 < ApplicationService::Base
      output :number, type: Integer

      make :assign_number_4

      stage do
        rollback :method_for_rollback

        make :assign_number_5
        make :assign_number_6
        make :assign_number_7
      end

      private

      def assign_number_4
        outputs.number = 4
      end

      def assign_number_5
        outputs.number = 5
      end

      def assign_number_6
        raise "bad number"
      end

      def assign_number_7
        outputs.number = 7
      end

      def method_for_rollback(_e) # rubocop:disable Naming/MethodParameterName
        outputs.number = 9
      end
    end
  end
end
