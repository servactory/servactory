# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Schema
      class Example16Payload
        extend Forwardable

        def_delegators :@attributes, :fetch, :[], :[]=

        def initialize(attributes = {})
          @attributes = attributes.dup
        end
      end

      class Example16Parent < ApplicationService::Base
        configuration do
          hash_mode_class_names([Example16Payload])
        end
      end

      class Example16 < Example16Parent
        input :payload,
              type: Example16Payload,
              schema: {
                first_name: { type: String },
                middle_name: { type: String, required: false, default: "Unknown" }
              }

        output :payload, type: Example16Payload

        make :assign_output

        private

        def assign_output
          outputs.payload = inputs.payload
        end
      end
    end
  end
end
