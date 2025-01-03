# frozen_string_literal: true

module Servactory
  module Inputs
    module Tools
      class Warehouse
        def self.assign(...)
          new(...).assign
        end

        def initialize(context, incoming_arguments)
          @context = context
          @incoming_arguments = incoming_arguments
        end

        def assign
          @context.send(:servactory_service_warehouse).assign_inputs(adapted_arguments)
        end

        private

        def adapted_arguments
          Servactory::Utils.adapt(@incoming_arguments)
        end
      end
    end
  end
end
