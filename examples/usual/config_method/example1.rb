# frozen_string_literal: true

module Usual
  module ConfigMethod
    class Example1 < ApplicationService::Base
      input :host, type: String
      input :secure, type: [TrueClass, FalseClass]

      internal :port, type: Integer

      output :url, type: String
      output :secure, type: [TrueClass, FalseClass]

      make :assign_port
      make :assign_url
      make :assign_secure

      private

      def assign_port
        internals.port = config.fetch(inputs.secure? ? :secure_port : :port)
      end

      def assign_url
        return unless internals.port?

        scheme = inputs.secure? ? "https" : "http"

        outputs.url = "#{scheme}://#{inputs.host}:#{internals.port}"
      end

      def assign_secure
        outputs.secure = outputs.url? && inputs.secure?
      end

      def config
        {
          port: 80,
          secure_port: 443
        }
      end
    end
  end
end
