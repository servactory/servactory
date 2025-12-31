# frozen_string_literal: true

module Servactory
  module Stroma
    class Configuration
      attr_reader :hooks

      def initialize
        @hooks = Hooks.new
      end

      def initialize_dup(original)
        super
        @hooks = original.instance_variable_get(:@hooks).dup
      end
    end
  end
end
