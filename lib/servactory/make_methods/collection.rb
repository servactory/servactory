# frozen_string_literal: true

module Servactory
  module MakeMethods
    class Collection
      # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
      extend Forwardable
      def_delegators :@collection, :<<, :each, :merge

      def initialize(*)
        @collection = Set.new
      end
    end
  end
end
