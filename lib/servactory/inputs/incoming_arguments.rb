# frozen_string_literal: true

module Servactory
  module Inputs
    class IncomingArguments
      attr_reader :arguments

      def initialize(config, **arguments)
        @config = config
        @arguments = arguments
      end

      def names
        @arguments.keys
      end

      # def fetch!(name)
      #   @arguments.fetch(name)
      # end

      def fetch(name, default_value)
        @arguments.fetch(name, default_value)
      end

      # def []=(key, value)
      #   @arguments[key] = value
      # end

      def assign(key, value)
        @arguments[key] = value
      end

      ##########################################################################

      def method_missing(name, *args, &block)
        input_name = @config.predicate_methods_enabled? ? name.to_s.chomp("?").to_sym : name

        input_value = @arguments.fetch(input_name) { super }

        if name.to_s.end_with?("?") && @config.predicate_methods_enabled?
          Servactory::Utils.query_attribute(input_value)
        else
          input_value
        end
      end

      def respond_to_missing?(name, *)
        @arguments.fetch(name) { super }
      end
    end
  end
end
