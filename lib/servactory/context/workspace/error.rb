# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Error
        attr_reader :type,
                    :message,
                    :attribute_name

        def initialize(type:, message:, attribute_name: nil)
          @type = type.to_sym
          @message = message
          @attribute_name = attribute_name if @type == :input
        end
      end
    end
  end
end
