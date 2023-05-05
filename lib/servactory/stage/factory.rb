# frozen_string_literal: true

module Servactory
  module Stage
    class Factory
      def make(name, **options)
        methods << Method.new(name, **options)
      end

      def methods
        @methods ||= Methods.new
      end
    end
  end
end