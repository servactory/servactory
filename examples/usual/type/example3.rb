# frozen_string_literal: true

module Usual
  module Type
    class Example3 < ApplicationService::Base
      input :payload, type: Hash

      input :options,
            type: { is: Hash },
            required: false,
            default: { verbose: false }

      input :limit,
            type: {
              is: Integer,
              message: "Input `limit` must be an Integer"
            },
            required: false,
            default: 10

      output :payload, type: Hash

      output :verbose, type: [TrueClass, FalseClass]

      output :limit, type: Integer

      make :assign_outputs

      private

      def assign_outputs
        outputs.payload = inputs.payload
        outputs.verbose = inputs.options.fetch(:verbose)
        outputs.limit = inputs.limit
      end
    end
  end
end
