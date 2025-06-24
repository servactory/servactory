# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Schema
      class ExampleCollectionInvalid < ApplicationService::Base
        ITEM_SCHEMA = {
          id: { type: Integer, required: true },
          name: { type: String, required: true }
        }.freeze
        private_constant :ITEM_SCHEMA

        input :items, type: Array, consists_of: Hash, schema: ITEM_SCHEMA
        output :first_item_name, type: String

        make :assign_first_item_name

        private

        def assign_first_item_name
          outputs.first_item_name = inputs.items.first[:name]
        end
      end
    end
  end
end 