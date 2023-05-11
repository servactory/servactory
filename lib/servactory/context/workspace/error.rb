# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Error
        attr_reader :section,
                    :message

        def initialize(section, message)
          @section = section
          @message = message
        end
      end
    end
  end
end
