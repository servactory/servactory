# frozen_string_literal: true

module Usual
  module Basic
    class Example17 < ApplicationService::Base
      input :first_name,
            type: String,
            required: {
              message: lambda do |service:, input:, value:|
                "[#{service.class_name}] Input `#{input.name}` is required, got #{value.inspect}"
              end
            }
      input :last_name, type: String

      output :full_name, type: String

      make :assign_full_name

      private

      def assign_full_name
        outputs.full_name = [inputs.first_name, inputs.last_name].join(" ")
      end
    end
  end
end
