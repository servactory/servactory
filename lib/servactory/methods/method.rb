# frozen_string_literal: true

module Servactory
  module Methods
    class Method
      attr_reader :name,
                  :condition,
                  :is_condition_opposite

      def initialize(name, **options)
        @name = name

        @is_condition_opposite = false
        @condition = options.fetch(:if, nil)

        return unless @condition.nil?

        @condition = options.fetch(:unless, nil)

        @is_condition_opposite = true unless @condition.nil?
      end
    end
  end
end
