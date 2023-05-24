# frozen_string_literal: true

module ApplicationService
  class Base < Servactory::Base
    configuration do
      input_attribute_error_class ApplicationService::Errors::InputError
      output_attribute_error_class ApplicationService::Errors::OutputError
      internal_attribute_error_class ApplicationService::Errors::InternalError

      failure_class ApplicationService::Errors::Failure
    end
  end
end
