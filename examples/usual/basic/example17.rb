# frozen_string_literal: true

module Usual
  module Basic
    class Example17 < ApplicationService::Base
      input :need, type: [TrueClass, FalseClass]

      output :need, type: [TrueClass, FalseClass]

      make :assign_need

      private

      def assign_need
        outputs.need = inputs.need
      end
    end
  end
end
