# frozen_string_literal: true

module ApplicationService
  module Errors
    class InputArgumentError < ServiceFactory::Errors::InputArgumentError; end
    class OutputArgumentError < ServiceFactory::Errors::OutputArgumentError; end
    class InternalArgumentError < ServiceFactory::Errors::InternalArgumentError; end

    class Failure < ServiceFactory::Errors::Failure; end
  end
end
