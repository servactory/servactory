# frozen_string_literal: true

module Usual
  module Hash
    class Example6 < ApplicationService::Base
      input :payload, type: ::Hash

      internal :payload, type: ::Hash

      output :payload, type: ::Hash

      output :full_name, type: String

      make :assign_internal

      make :assign_output

      make :assign_full_name

      private

      def assign_internal
        internals.payload = inputs.payload
      end

      def assign_output
        outputs.payload = internals.payload
      end

      def assign_full_name
        outputs.full_name = [
          outputs.payload.dig(:user, :first_name),
          outputs.payload.dig(:user, :middle_name),
          outputs.payload.dig(:user, :last_name)
        ].compact.join(" ")
      end
    end
  end
end
