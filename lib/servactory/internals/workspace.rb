# frozen_string_literal: true

module Servactory
  module Internals
    module Workspace
      private

      def call!(collection_of_internals:, **)
        super

        Tools::ReservedNames.check!(self, collection_of_internals)
      end
    end
  end
end
