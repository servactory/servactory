# frozen_string_literal: true

module Servactory
  module DSL
    @extensions = []

    def self.included(base)
      base.include(Configuration::DSL)
      base.include(Info::DSL)
      base.include(Context::DSL)
      base.include(Inputs::DSL)
      base.include(Internals::DSL)
      base.include(Outputs::DSL)

      extensions.each { |extension| base.include(extension) }

      base.include(Methods::DSL)
    end

    def self.with_extensions(*extensions)
      @extensions = extensions

      self
    end

    def self.extensions
      @extensions
    end

    private_class_method :extensions
  end
end
