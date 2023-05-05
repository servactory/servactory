# frozen_string_literal: true

module ServiceFactory
  module Stage
    class Method
      attr_reader :name, :condition

      def initialize(name, **options)
        @name = name

        @condition = options.fetch(:if, nil)
      end

      # def options
      #   {
      #     condition:
      #   }
      # end
    end
  end
end
