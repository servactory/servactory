# frozen_string_literal: true

module Usual
  module ConfigMethod
    class Example4 < ApplicationService::Base
      input :host, type: String

      output :url, type: String

      make :use_cached_url!
      make :assign_url

      private

      def use_cached_url!
        cached_url = config.fetch(:cached_urls)[inputs.host]
        return if cached_url.nil?

        outputs.url = cached_url

        success!
      end

      def assign_url
        outputs.url = "https://#{inputs.host}"
      end

      def config
        {
          cached_urls: { "example.com" => "https://cdn.example.com" }
        }
      end
    end
  end
end
