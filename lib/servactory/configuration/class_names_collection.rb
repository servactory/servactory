# frozen_string_literal: true

module Servactory
  module Configuration
    class ClassNamesCollection
      extend Forwardable
      def_delegators :@collection, :merge, :intersection

      def initialize(collection)
        @collection = collection
      end
    end
  end
end
