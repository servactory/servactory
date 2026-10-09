# frozen_string_literal: true

module Usual
  module ConfigMethod
    class Example3 < ApplicationService::Base
      configuration do
        predicate_methods_enabled false
      end

      input :host, type: String

      output :url, type: String

      make :assign_url

      def config
        { scheme: "https" }
      end

      private

      def assign_url
        outputs.url = "#{config.fetch(:scheme)}://#{inputs.host}"
      end
    end
  end
end
