# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      class DefineMethod
        attr_reader :name,
                    :content

        def initialize(name:, content:)
          @name = name.to_sym
          @content = content
        end
      end
    end
  end
end
