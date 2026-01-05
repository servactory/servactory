# frozen_string_literal: true

module AlternativeService
  class Base < Servactory::Base
    configuration do
      input_exception_class AlternativeService::Exceptions::Input
      internal_exception_class AlternativeService::Exceptions::Internal
      output_exception_class AlternativeService::Exceptions::Output

      failure_class AlternativeService::Exceptions::Failure

      result_class AlternativeService::Result

      i18n_root_key :servactory

      predicate_methods_enabled true
    end
  end
end
