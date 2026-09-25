# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Schema
      class Example13 < ApplicationService::Base
        PAYLOAD_SCHEMA = {
          meta: {
            type: ::Hash,
            a: { type: String }
          },
          name: { type: String }
        }.freeze
        private_constant :PAYLOAD_SCHEMA

        input :payload,
              type: ::Hash,
              schema: PAYLOAD_SCHEMA

        internal :payload,
                 type: ::Hash,
                 schema: PAYLOAD_SCHEMA

        output :payload,
               type: ::Hash,
               schema: PAYLOAD_SCHEMA

        make :assign_internal

        make :assign_output

        private

        def assign_internal
          internals.payload = inputs.payload
        end

        def assign_output
          outputs.payload = internals.payload
        end
      end
    end
  end
end
