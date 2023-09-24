# frozen_string_literal: true

module Servactory
  module DSL
    @@extensions = {}

    def self.included(base)
      base.include(Configuration::DSL)
      base.include(Info::DSL)
      base.include(Context::DSL)
      base.include(Inputs::DSL)
      base.include(Internals::DSL)
      base.include(Outputs::DSL)

      before_methods_extensions.each { |before_methods_extension| base.include(before_methods_extension) }
      base.include(Methods::DSL)
    end

    def self.extensions(extensions)
      @@extensions = extensions

      self
    end

    def self.before_methods_extensions
      @@extensions.fetch(:before_methods, [])
    end

    private_class_method :before_methods_extensions
  end
end
