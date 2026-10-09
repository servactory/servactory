# frozen_string_literal: true

module Usual
  module Type
    class Example2 < ApplicationService::Base
      input :number,
            type: {
              is: [Integer, Float, String],
              message: lambda do |service:, input:, value:, expected_type:, given_type:, **|
                "[#{service.class_name}] Input `#{input.name}` received `#{value.inspect}` " \
                  "of type `#{given_type}`, expected `#{expected_type}`"
              end
            }

      internal :number,
               type: {
                 is: [Integer, Float],
                 message: lambda do |internal:, value:, expected_type:, given_type:, **|
                   "Internal attribute `#{internal.name}` received `#{value.inspect}` " \
                     "of type `#{given_type}`, expected `#{expected_type}`"
                 end
               }

      output :number,
             type: {
               is: Integer,
               message: lambda do |output:, value:, expected_type:, given_type:, **|
                 "Output attribute `#{output.name}` received `#{value.inspect}` " \
                   "of type `#{given_type}`, expected `#{expected_type}`"
               end
             }

      make :assign_internal_number

      make :assign_output_number

      private

      def assign_internal_number
        internals.number = inputs.number
      end

      def assign_output_number
        outputs.number = internals.number
      end
    end
  end
end
