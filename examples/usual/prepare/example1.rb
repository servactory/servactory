# frozen_string_literal: true

module Usual
  module Prepare
    class Example1 < ApplicationService::Base
      Money = Struct.new(:cents, :currency, keyword_init: true) do
        def +(other)
          self.class.new(cents: cents + other.cents, currency:)
        end
      end

      BONUS = Money.new(cents: 1_000_00, currency: :USD)

      private_constant :BONUS

      ############################################################################

      input :balance_cents,
            as: :balance,
            type: Integer,
            prepare: ->(value:, **) { Money.new(cents: value, currency: :USD) }

      output :balance_with_bonus, type: Money

      make :assign_balance_with_bonus

      private

      def assign_balance_with_bonus
        outputs.balance_with_bonus = inputs.balance + BONUS
      end
    end
  end
end
