# frozen_string_literal: true

module Servactory
  module Inputs
    module Workspace
      private

      def call!(incoming_arguments:, collection_of_inputs:, **)
        super

        Tools::FindUnnecessary.validate!(self, incoming_arguments, collection_of_inputs)
        Tools::Rules.validate!(self, collection_of_inputs)
        Servactory::Inputs::Tools::Validation.validate!(self, incoming_arguments, collection_of_inputs)
      end
    end
  end
end
