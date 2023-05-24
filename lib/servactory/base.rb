# frozen_string_literal: true

module Servactory
  class Base
    include Configuration::DSL
    include Context::DSL
    include Inputs::DSL
    include InternalAttributes::DSL
    include Outputs::DSL
    include MakeMethods::DSL

    private_class_method :new
  end
end
