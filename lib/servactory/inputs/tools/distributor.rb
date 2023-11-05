# frozen_string_literal: true

module Servactory
  module Inputs
    module Tools
      class Distributor
        def self.assign!(...)
          new(...).assign!
        end

        def initialize(incoming_arguments, collection_of_inputs)
          @incoming_arguments = incoming_arguments
          @collection_of_inputs = collection_of_inputs
        end

        def assign!
          @collection_of_inputs.map do |input|
            input.value = @incoming_arguments.fetch(input.name, nil)
          end
        end
      end
    end
  end
end
