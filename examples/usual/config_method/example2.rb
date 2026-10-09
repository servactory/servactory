# frozen_string_literal: true

module Usual
  module ConfigMethod
    class Example2 < ApplicationService::Base
      input :host, type: String

      output :url, type: String

      make :check_host!
      make :assign_url

      private

      def check_host!
        if config.fetch(:blocked_hosts).include?(inputs.host)
          fail_input!(:host, message: "Blocked host", meta: { host: inputs.host })
        end

        return if config.fetch(:allowed_hosts).include?(inputs.host)

        fail!(message: "Unknown host", meta: { host: inputs.host })
      end

      def assign_url
        outputs.url = "https://#{inputs.host}"
      end

      def config
        {
          allowed_hosts: %w[example.com],
          blocked_hosts: %w[blocked.example.com]
        }
      end
    end
  end
end
