# frozen_string_literal: true

module Servactory
  module Methods
    class Method
      attr_reader :name,
                  :condition

      def initialize(name, **options)
        @name = name

        @condition = options.fetch(:if, nil)
      end
    end
  end
end
