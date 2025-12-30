# frozen_string_literal: true

module Servactory
  module Stroma
    class Configuration
      attr_reader :hooks

      def initialize
        @hooks = Hooks.new
      end

      def dup_for_inheritance
        self.class.new.tap do |copy|
          copy.instance_variable_set(:@hooks, @hooks.dup_for_inheritance)
        end
      end
    end
  end
end
