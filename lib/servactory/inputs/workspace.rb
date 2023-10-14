# frozen_string_literal: true

module Servactory
  module Inputs
    module Workspace
      private

      def call!(incoming_arguments:, collection_of_inputs:, **)
        super

        Tools::FindUnnecessary.find!(self, incoming_arguments, collection_of_inputs)
        Tools::Distributor.assign!(incoming_arguments, collection_of_inputs)
        Tools::Rules.check!(self, collection_of_inputs)
        Tools::Validation.validate!(self, collection_of_inputs)
      end
    end
  end
end
