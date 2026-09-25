# frozen_string_literal: true

module Wrong
  module DynamicOptions
    module Schema
      class Example15 < ApplicationService::Base
        internal :payload,
                 type: ActiveSupport::HashWithIndifferentAccess,
                 schema: {
                   name: { type: String }
                 }

        make :assign_internal

        private

        def assign_internal
          internals.payload = ActiveSupport::HashWithIndifferentAccess.new(name: "John")
        end
      end
    end
  end
end
