# frozen_string_literal: true

module ServiceFactory
  class Base
    include Context::DSL
    include InputArguments::DSL
    include InternalArguments::DSL
    include OutputArguments::DSL
    include Stage::DSL
  end
end
