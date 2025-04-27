# frozen_string_literal: true

module Servactory
  class Base
    include OldConfiguration::DSL
    include Info::DSL
    include Context::DSL
    include Inputs::DSL
    include Internals::DSL
    include Outputs::DSL
    include Actions::DSL

    private_class_method :new
  end
end
