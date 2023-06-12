# frozen_string_literal: true

module Servactory
  module Methods
    class Stage
      attr_accessor :position,
                    :wrapper,
                    :rollback,
                    :condition

      def initialize(position:, wrapper: nil, rollback: nil, condition: nil)
        @position = position
        @wrapper = wrapper
        @rollback = rollback
        @condition = condition
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
