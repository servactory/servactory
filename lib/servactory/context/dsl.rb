# frozen_string_literal: true

module Servactory
  module Context
    module DSL
      def self.included(base)
        base.extend(Callable)
        base.extend(Configurable)
        base.prepend(Workspace)
      end

      module Configurable
        def configuration(&block)
          context_configuration = Servactory::Context::Configuration.new

          context_configuration.instance_eval(&block)
        end
      end
    end
  end
end
