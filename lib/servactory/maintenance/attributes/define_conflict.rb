# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      class DefineConflict
        attr_reader :content

        def initialize(content:)
          @content = content
        end
      end
    end
  end
end
