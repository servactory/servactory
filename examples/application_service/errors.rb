# frozen_string_literal: true

module ApplicationService
  module Errors
    class InputError < Servactory::Errors::InputError; end
    class OutputAttributeError < Servactory::Errors::OutputAttributeError; end
    class InternalAttributeError < Servactory::Errors::InternalAttributeError; end

    class Failure < Servactory::Errors::Failure; end
  end
end
