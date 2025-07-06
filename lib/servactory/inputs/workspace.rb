# frozen_string_literal: true

module Servactory
  module Inputs
    module Workspace
      private

      def call!(**)
        super

        Tools::Unnecessary.find!(self, collection_of_inputs)
        Tools::Rules.check!(self, collection_of_inputs)
        Tools::Validation.validate!(self, collection_of_inputs)
      end
    end
  end
end
