# frozen_string_literal: true

module Servactory
  module Methods
    class Stage
      attr_accessor :position,
                    :wrapper,
                    :rollback

      def initialize(position:, wrapper: nil, rollback: nil)
        # @code = code
        @position = position
        @wrapper = wrapper
        @rollback = rollback
      end

      def next_method_position
        methods.size + 1
      end

      def methods
        @methods ||= MethodCollection.new
      end
    end
  end
end
