# frozen_string_literal: true

module Servactory
  module OldConfiguration
    class Factory
      def initialize(config)
        @config = config
      end

      def domain(domain)
        @config.domain = domain
      end
    end
  end
end
