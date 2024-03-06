# frozen_string_literal: true

module ApplicationService
  module Errors
    # DEPRECATED: This class will be deleted after release 2.4.
    class InputError < Servactory::Errors::InputError; end
    # DEPRECATED: This class will be deleted after release 2.4.
    class OutputError < Servactory::Errors::OutputError; end
    # DEPRECATED: This class will be deleted after release 2.4.
    class InternalError < Servactory::Errors::InternalError; end

    # DEPRECATED: This class will be deleted after release 2.4.
    class Failure < Servactory::Errors::Failure; end
  end
end
