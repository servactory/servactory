# frozen_string_literal: true

module ApplicationService
  class Base
    include Servactory::DSL

    # More information: https://servactory.com/guide/extensions
    # include Servactory::DSL.with_extensions(
    #   ApplicationService::Extensions::YourExtension::DSL
    # )

    fail_on! ActiveRecord::RecordInvalid

    # More information: https://servactory.com/guide/configuration
    configuration do
      input_exception_class ApplicationService::Exceptions::Input
      internal_exception_class ApplicationService::Exceptions::Internal
      output_exception_class ApplicationService::Exceptions::Output

      failure_class ApplicationService::Exceptions::Failure

      result_class ApplicationService::Result

      # input_option_helpers(
      #   [
      #     Servactory::ToolKit::DynamicOptions::Format.use,
      #     Servactory::ToolKit::DynamicOptions::Min.use,
      #     Servactory::ToolKit::DynamicOptions::Max.use,
      #     ApplicationService::DynamicOptions::CustomEq.use
      #   ]
      # )

      # internal_option_helpers(
      #   [
      #     Servactory::ToolKit::DynamicOptions::Format.use,
      #     Servactory::ToolKit::DynamicOptions::Min.use,
      #     Servactory::ToolKit::DynamicOptions::Max.use,
      #     ApplicationService::DynamicOptions::CustomEq.use
      #   ]
      # )

      # output_option_helpers(
      #   [
      #     Servactory::ToolKit::DynamicOptions::Format.use,
      #     Servactory::ToolKit::DynamicOptions::Min.use,
      #     Servactory::ToolKit::DynamicOptions::Max.use,
      #     ApplicationService::DynamicOptions::CustomEq.use
      #   ]
      # )

      # collection_mode_class_names [ActiveRecord::Relation]

      # hash_mode_class_names [CustomHash]

      # action_shortcuts(
      #   %i[assign build create save],
      #   {
      #     restrict: {
      #       prefix: :create,
      #       suffix: :restriction
      #     }
      #   }
      # )

      # action_aliases %i[do_it!]

      # i18n_root_key :servactory

      # predicate_methods_enabled false
    end
  end
end
