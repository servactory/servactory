# frozen_string_literal: true

module ApplicationService
  module Errors
    class InputAttributeError < Servactory::Errors::InputAttributeError; end
    class OutputAttributeError < Servactory::Errors::OutputAttributeError; end
    class InternalAttributeError < Servactory::Errors::InternalAttributeError; end

    class Failure < Servactory::Errors::Failure; end
  end
end
