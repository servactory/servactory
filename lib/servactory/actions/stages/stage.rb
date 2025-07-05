# frozen_string_literal: true

module Servactory
  module Actions
    module Stages
      class Stage
        attr_accessor :position,
                      :wrapper,
                      :rollback,
                      :condition,
                      :is_condition_opposite

        def initialize(position:, wrapper: nil, rollback: nil, condition: nil)
          @position = position
          @wrapper = wrapper
          @rollback = rollback
          @condition = condition
        end

        def actions
          @actions ||= Servactory::Actions::Collection.new
        end
      end
    end
  end
end
