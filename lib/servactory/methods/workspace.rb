# frozen_string_literal: true

module Servactory
  module Methods
    module Workspace
      def call!(collection_of_stages:, **)
        super

        Servactory::Methods::Tools::Runner.run!(self, collection_of_stages)
      end
    end
  end
end
