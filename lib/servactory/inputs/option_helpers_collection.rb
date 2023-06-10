# frozen_string_literal: true

module Servactory
  module Inputs
    class OptionHelpersCollection
      # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
      extend Forwardable
      def_delegators :@collection, :<<, :find, :merge

      def initialize(collection)
        @collection = collection
      end

      def find_by(name:)
        find { |helper| helper.name == name }
      end
    end
  end
end
