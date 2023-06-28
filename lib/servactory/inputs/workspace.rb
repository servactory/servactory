# frozen_string_literal: true

module Servactory
  module Inputs
    module Workspace
      def call!(incoming_arguments:, collection_of_inputs:, **)
        super

        Servactory::Inputs::Tools::Validation.validate!(self, incoming_arguments, collection_of_inputs)
      end
    end
  end
end
