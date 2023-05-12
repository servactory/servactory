# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Error
        attr_reader :type,
                    :message,
                    :attribute_name

        def initialize(type:, message:, attribute_name: nil)
          @type = type
          @message = message
          @attribute_name = attribute_name
        end
      end
    end
  end
end
