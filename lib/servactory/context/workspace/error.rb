# frozen_string_literal: true

module Servactory
  module Context
    module Workspace
      class Error
        attr_reader :type,
                    :message,
                    :attribute_name,
                    :meta

        def initialize(type:, message:, attribute_name: nil, meta: nil)
          @type = type.to_sym
          @message = message
          @attribute_name = attribute_name if @type == :input
          @meta = meta
        end
      end
    end
  end
end
