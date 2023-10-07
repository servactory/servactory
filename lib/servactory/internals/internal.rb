# frozen_string_literal: true

module Servactory
  module Internals
    class Internal
      attr_reader :name,
                  :types

      def initialize(name, type:, **options)
        @name = name
        @types = Array(type)
      end

      def options_for_checks
        {
          types: types
        }
      end
    end
  end
end
