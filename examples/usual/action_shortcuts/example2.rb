# frozen_string_literal: true

module Usual
  module ActionShortcuts
    class Example2 < ApplicationService::Base
      PaymentRestriction = Struct.new(:reason, keyword_init: true)

      restrict :payment!

      private

      def create_payment_restriction!
        PaymentRestriction.new(
          reason: "Suspicion of fraud"
        )
      end
    end
  end
end
