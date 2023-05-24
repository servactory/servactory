# frozen_string_literal: true

module ApplicationService
  module Errors
    class InputError < Servactory::Errors::InputError; end
    class OutputError < Servactory::Errors::OutputError; end
    class InternalAttributeError < Servactory::Errors::InternalAttributeError; end

    class Failure < Servactory::Errors::Failure; end
  end
end
