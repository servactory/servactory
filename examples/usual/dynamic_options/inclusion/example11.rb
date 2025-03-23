# frozen_string_literal: true

module Usual
  module DynamicOptions
    module Inclusion
      class Example11 < ApplicationService::Base
        FakeEntity = Struct.new(:id)

        FirstEntity = Struct.new(:id)
        SecondEntity = Struct.new(:id)
        ThirdEntity = Struct.new(:id)

        input :entity_class,
              type: Class,
              inclusion: {
                in: [FirstEntity, SecondEntity, ThirdEntity]
              }

        internal :entity_class,
                 type: Class,
                 inclusion: {
                   in: [SecondEntity, ThirdEntity]
                 }

        output :entity_class,
               type: Class,
               inclusion: {
                 in: [ThirdEntity]
               }

        make :assign_attributes

        private

        def assign_attributes
          # NOTE: Here we check how `inclusion` works for `internal` and `output`
          internals.entity_class = inputs.entity_class
          outputs.entity_class = internals.entity_class
        end
      end
    end
  end
end
