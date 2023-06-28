# frozen_string_literal: true

module Servactory
  module Outputs
    module Workspace
      def call!(collection_of_internals:, collection_of_outputs:, **)
        super

        Tools::Conflicts.validate!(self, collection_of_outputs, collection_of_internals)
      end
    end
  end
end
