# frozen_string_literal: true

module Servactory
  module Methods
    class Method
      attr_reader :name,
                  :position,
                  :wrapper,
                  :condition,
                  :is_condition_opposite

      def initialize(name, position:, **options)
        @name = name
        @position = position

        @wrapper = options.fetch(:wrapper, nil)

        @is_condition_opposite = false
        @condition = options.fetch(:if, nil)

        return unless @condition.nil?

        @condition = options.fetch(:unless, nil)

        @is_condition_opposite = true unless @condition.nil?
      end
    end
  end
end
