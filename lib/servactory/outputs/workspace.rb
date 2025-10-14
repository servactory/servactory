# frozen_string_literal: true

module Servactory
  module Outputs
    module Workspace
      private

      def call!(collection_of_outputs:, **)
        super

        Tools::ReservedNames.check!(self, collection_of_outputs)
      end
    end
  end
end
