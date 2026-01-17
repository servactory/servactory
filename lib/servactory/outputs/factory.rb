# frozen_string_literal: true

module Servactory
  module Outputs
    class Factory
      def initialize(config, collection_of_outputs)
        @option_helpers = config.output_option_helpers
        @collection_of_outputs = collection_of_outputs
      end

      def method_missing(name, *helpers, **options)
        @collection_of_outputs << Output.new(
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
