# frozen_string_literal: true

module Servactory
  class Base
    include Configuration::DSL
    include Context::DSL
    include InputArguments::DSL
    include InternalArguments::DSL
    include OutputArguments::DSL
    include Stage::DSL

    private_class_method :new
  end
end
