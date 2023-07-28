# frozen_string_literal: true

module Servactory
  module DSL
    def self.included(base)
      base.include(Configuration::DSL)
      base.include(Info::DSL)
      base.include(Context::DSL)
      base.include(Inputs::DSL)
      base.include(Internals::DSL)
      base.include(Outputs::DSL)
      base.include(Methods::DSL)
    end
  end
end
