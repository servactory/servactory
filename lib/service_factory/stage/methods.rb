# frozen_string_literal: true

module ServiceFactory
  module Stage
    class Methods
      # NOTE: http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
      extend Forwardable
      def_delegators :@methods, :<<, :each

      def initialize(*)
        @methods = []
      end
    end
  end
end
