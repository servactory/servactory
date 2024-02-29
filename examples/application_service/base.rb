# frozen_string_literal: true

require_relative "extensions/status_active/dsl"

module ApplicationService
  class Base
    include Servactory::DSL.with_extensions(
      ApplicationService::Extensions::StatusActive::DSL
    )

    configuration do
      input_exception_class ApplicationService::Exceptions::Input
      internal_exception_class ApplicationService::Exceptions::Internal
      output_exception_class ApplicationService::Exceptions::Output

      # DEPRECATED: These configs must be deleted after release 2.4.
      # input_error_class ApplicationService::Exceptions::Input
      # internal_error_class ApplicationService::Exceptions::Internal
      # output_error_class ApplicationService::Exceptions::Output

      failure_class ApplicationService::Exceptions::Failure
    end
  end
end
