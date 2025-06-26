# frozen_string_literal: true

module Servactory
  module Actions
    module Workspace
      private

      def call!(collection_of_stages:, **_options)
        super

        Servactory::Actions::Tools::Rules.check!(self)
        Servactory::Actions::Tools::Runner.run!(self, collection_of_stages)
      end
    end
  end
end
