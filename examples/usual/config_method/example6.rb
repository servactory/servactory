# frozen_string_literal: true

module Usual
  module ConfigMethod
    class Example6 < ApplicationService::Base
      class UnknownHostError < KeyError; end

      fail_on! UnknownHostError, with: ->(exception:) { "Unknown host: #{exception.message}" }

      input :host, type: String

      output :address, type: String

      make :assign_address

      private

      def assign_address
        outputs.address = config.fetch(:addresses).fetch(inputs.host) do
          raise UnknownHostError, inputs.host
        end
      end

      def config
        {
          addresses: { "example.com" => "192.0.2.1" }
        }
      end
    end
  end
end
