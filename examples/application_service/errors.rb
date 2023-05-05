# frozen_string_literal: true

module ApplicationService
  module Errors
    class InputArgumentError < Servactory::Errors::InputArgumentError; end
    class OutputArgumentError < Servactory::Errors::OutputArgumentError; end
    class InternalArgumentError < Servactory::Errors::InternalArgumentError; end

    class Failure < Servactory::Errors::Failure; end
  end
end
