# frozen_string_literal: true

module Servactory
  module InputAttributes
    class DefineInputConflict
      attr_reader :content

      def initialize(content:)
        @content = content
      end
    end
  end
end
