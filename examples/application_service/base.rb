# frozen_string_literal: true

require_relative "extensions/status_active/dsl"

module ApplicationService
  class Base
    include Servactory::DSL.with_extensions(
      ApplicationService::Extensions::StatusActive::DSL
    )


    configuration do
      # DEPRECATED: Use `Servactory::Exceptions::Input` instead
      # input_error_class ApplicationService::Errors::InputError
      # DEPRECATED: Use `Servactory::Exceptions::Internal` instead
      # internal_error_class ApplicationService::Errors::InternalError
      # DEPRECATED: Use `Servactory::Exceptions::Output` instead
      # output_error_class ApplicationService::Errors::OutputError

      # DEPRECATED: Use `Servactory::Exceptions::Failure` instead
      # failure_class ApplicationService::Errors::Failure

      input_error_class ApplicationService::Exceptions::Input
      internal_error_class ApplicationService::Exceptions::Internal
      output_error_class ApplicationService::Exceptions::Output

      failure_class ApplicationService::Exceptions::Failure
    end
  end
end
