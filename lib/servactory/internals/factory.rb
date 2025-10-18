# frozen_string_literal: true

module Servactory
  module Internals
    class Factory
      def initialize(config, collection_of_internals)
        @option_helpers = config.internal_option_helpers
        @collection_of_internals = collection_of_internals
      end

      def method_missing(name, *helpers, **options)
        @collection_of_internals << Internal.new(
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
