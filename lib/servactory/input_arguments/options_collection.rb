# frozen_string_literal: true

module Servactory
  module InputArguments
    class OptionsCollection
      # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
      extend Forwardable
      def_delegators :@collection, :<<, :each, :select, :map

      def initialize(*)
        @collection = []
      end

      def check_classes
        select { |option| option.check_class.present? }.map(&:check_class).uniq
      end
    end
  end
end
