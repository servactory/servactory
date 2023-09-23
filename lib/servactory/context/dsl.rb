# frozen_string_literal: true

module Servactory
  module Context
    module DSL
      def self.included(base)
        base.extend(Callable)
        base.extend(InstanceOverride)
        base.include(Workspace)
      end

      module InstanceOverride
        def instance_override(&block)
          class_eval(&block)
        end
      end
    end
  end
end
