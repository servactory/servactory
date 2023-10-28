# frozen_string_literal: true

module Servactory
  module Actions
    class Action
      attr_reader :name,
                  :position,
                  :condition,
                  :is_condition_opposite

      def initialize(name, position:, **options)
        @name = name
        @position = position

        @is_condition_opposite = false
        @condition = options.fetch(:if, nil)

        return unless @condition.nil?

        @condition = options.fetch(:unless, nil)

        @is_condition_opposite = true unless @condition.nil?
      end
    end
  end
end
