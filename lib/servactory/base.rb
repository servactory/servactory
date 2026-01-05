# frozen_string_literal: true

module Servactory
  class Base
    include Servactory::DSL

    private_class_method :new
  end
end
