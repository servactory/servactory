# frozen_string_literal: true

module Usual
  module ConfigMethod
    class Example5 < ApplicationService::Base
      input :host, type: String

      internal :port, type: Integer

      output :url, type: String

      make :assign_port
      make :check_port!
      make :assign_url

      private

      def assign_port
        internals.port = config.fetch(:ports).fetch(inputs.host, config.fetch(:default_port))
      end

      def check_port!
        return unless config.fetch(:reserved_ports).include?(internals.port)

        fail_internal!(:port, message: "Reserved port", meta: { port: internals.port })
      end

      def assign_url
        url = "https://#{inputs.host}:#{internals.port}"

        fail_output!(:url, message: "URL is too long", meta: { url: }) if url.length > config.fetch(:max_url_length)

        outputs.url = url
      end

      def config
        {
          default_port: 443,
          ports: { "ssh.example.com" => 22 },
          reserved_ports: [22],
          max_url_length: 30
        }
      end
    end
  end
end
