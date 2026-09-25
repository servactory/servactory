# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Schema
      class Example17Payload
        extend Forwardable

        def_delegators :@attributes, :fetch, :[], :[]=

        def initialize(attributes = {})
          @attributes = attributes.dup
        end
      end

      class Example17
        include Servactory::DSL

        configuration do
          hash_mode_class_names([Example17Payload])
        end

        input :payload,
              type: Example17Payload,
              schema: {
                first_name: { type: String },
                middle_name: { type: String, required: false, default: "Unknown" }
              }

        output :payload, type: Example17Payload

        make :assign_output

        private

        def assign_output
          outputs.payload = inputs.payload
        end
      end
    end
  end
end
