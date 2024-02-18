# frozen_string_literal: true

module ApplicationService
  # DEPRECATED: Use `Servactory::Exceptions` instead
  module Errors
    # DEPRECATED: Use `Servactory::Exceptions::Input` instead
    class InputError < Servactory::Errors::InputError; end
    # DEPRECATED: Use `Servactory::Exceptions::Internal` instead
    class InternalError < Servactory::Errors::InternalError; end
    # DEPRECATED: Use `Servactory::Exceptions::Output` instead
    class OutputError < Servactory::Errors::OutputError; end

    # DEPRECATED: Use `Servactory::Exceptions::Failure` instead
    class Failure < Servactory::Errors::Failure; end
  end
end
