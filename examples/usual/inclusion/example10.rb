# frozen_string_literal: true

module Usual
  module Inclusion
    class Example10 < ApplicationService::Base
      input :number,
            type: Integer,
            inclusion: {
              in: [1, 2, 3]
            }

      internal :number,
               type: Integer,
               inclusion: {
                 in: [2, 3]
               }

      output :number,
             type: Integer,
             inclusion: {
               in: [3]
             }

      make :assign_attributes

      private

      def assign_attributes
        # NOTE: Here we check how `inclusion` works for `internal` and `output`
        internals.number = inputs.number
        outputs.number = internals.number
      end
    end
  end
end
