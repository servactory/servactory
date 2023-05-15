# frozen_string_literal: true

module Servactory
  module InputArguments
    class DefineInputMethod
      attr_reader :name,
                  :content

      def initialize(name:, content:)
        @name = name.to_sym
        @content = content
      end
    end
  end
end
