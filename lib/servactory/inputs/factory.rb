# frozen_string_literal: true

module Servactory
  module Inputs
    class Factory
      def initialize(config, collection_of_inputs)
        @option_helpers = config.input_option_helpers
        @collection_of_inputs = collection_of_inputs
      end

      def method_missing(name, *helpers, **options)
        @collection_of_inputs << Input.new(
          name,
          *helpers,
          option_helpers: @option_helpers,
          **options
        )
      end

      def respond_to_missing?(name, *)
        super
      end
    end
  end
end
