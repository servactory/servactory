# frozen_string_literal: true

module Servactory
  class Base
    include Configuration::DSL
    include Context::DSL
    include Inputs::DSL
    include Internals::DSL
    include Outputs::DSL
    # include Methods::Stage::DSL
    include Methods::DSL

    private_class_method :new
  end
end
