# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Error
        attr_reader :type,
                    :message,
                    :name

        def initialize(type:, message:, name: nil)
          @type = type
          @message = message
          @name = name
        end
      end
    end
  end
end
