# frozen_string_literal: true

module Usual
  module ActionShortcuts
    class Example2 < ApplicationService::Base
      PaymentRestriction = Data.define(:code)

      restrict :payment!

      private

      def create_payment_restriction!
        PaymentRestriction.create!(
          reason: "Suspicion of fraud"
        )
      end
    end
  end
end
