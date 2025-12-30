# frozen_string_literal: true

require_relative "extensions/status_active/dsl"
require_relative "extensions/authorization/dsl"
require_relative "extensions/post_condition/dsl"
require_relative "extensions/transactional/dsl"
require_relative "extensions/rollbackable/dsl"
require_relative "extensions/publishable/dsl"
require_relative "extensions/idempotent/dsl"
require_relative "extensions/api_action/dsl"
require_relative "extensions/external_api_request/dsl"

module ApplicationService
  class Base # rubocop:disable Metrics/ClassLength
    # Extensions that run BEFORE actions (can access inputs, but outputs not yet set):
    # - StatusActive: checks if input model is active
    # - Authorization: checks authorization before actions run
    # - ApiAction: ClassMethods only, generates make calls
    # - ExternalApiRequest: rescues specific errors from actions
    #
    # Extensions that run AFTER actions (can access outputs):
    # - PostCondition: validates outputs after actions complete
    # - Transactional: wraps actions in transaction
    # - Rollbackable: calls rollback method on failure
    # - Publishable: publishes events after successful actions
    # - Idempotent: caches/returns outputs based on idempotency key
    include Servactory::DSL.with_extensions(
      ApplicationService::Extensions::StatusActive::DSL,
      ApplicationService::Extensions::Authorization::DSL,
      ApplicationService::Extensions::ApiAction::DSL
    )

    # After-actions extensions: included AFTER Servactory::DSL so they wrap the entire
    # call! chain including Actions::Workspace (which runs the actions)
    include ApplicationService::Extensions::PostCondition::DSL
    include ApplicationService::Extensions::Transactional::DSL
    include ApplicationService::Extensions::Rollbackable::DSL
    include ApplicationService::Extensions::Publishable::DSL
    include ApplicationService::Extensions::Idempotent::DSL
    include ApplicationService::Extensions::ExternalApiRequest::DSL

    FailOnLikeAnActiveRecordException = Class.new(ArgumentError)

    fail_on! FailOnLikeAnActiveRecordException

    configuration do # rubocop:disable Metrics/BlockLength
      input_exception_class ApplicationService::Exceptions::Input
      internal_exception_class ApplicationService::Exceptions::Internal
      output_exception_class ApplicationService::Exceptions::Output

      failure_class ApplicationService::Exceptions::Failure

      result_class ApplicationService::Result

      input_option_helpers(
        [
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: :must_be_6_characters,
            equivalent: {
              must: {
                be_6_characters: {
                  is: lambda do |value:, **|
                    value.all? do |id|
                      return true if id.blank? # NOTE: This is not the responsibility of this `must` validator

                      (id.is_a?(Integer) ? id.abs.digits.length : id.size) == 6
                    end
                  end,
                  message: lambda do |input:, **|
                    "Wrong IDs in `#{input.name}`"
                  end
                }
              }
            }
          ),
          Servactory::ToolKit::DynamicOptions::Format.use,
          Servactory::ToolKit::DynamicOptions::Min.use,
          Servactory::ToolKit::DynamicOptions::Max.use,
          Servactory::ToolKit::DynamicOptions::MultipleOf.use,
          Servactory::ToolKit::DynamicOptions::Target.use,
          ApplicationService::DynamicOptions::CustomEq.use
        ]
      )

      internal_option_helpers(
        [
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: :must_be_6_characters,
            equivalent: {
              must: {
                be_6_characters: {
                  is: lambda do |value:, **|
                    value.all? do |id|
                      return true if id.blank? # NOTE: This is not the responsibility of this `must` validator

                      (id.is_a?(Integer) ? id.abs.digits.length : id.size) == 6
                    end
                  end,
                  message: lambda do |internal:, **|
                    "Wrong IDs in `#{internal.name}`"
                  end
                }
              }
            }
          ),
          Servactory::ToolKit::DynamicOptions::Format.use(:check_format),
          Servactory::ToolKit::DynamicOptions::Min.use(:minimum), # Examples of
          Servactory::ToolKit::DynamicOptions::Max.use(:maximum), # custom names
          Servactory::ToolKit::DynamicOptions::MultipleOf.use(:divisible_by),
          Servactory::ToolKit::DynamicOptions::Target.use(:expect),
          ApplicationService::DynamicOptions::CustomEq.use(:best_custom_eq)
        ]
      )

      output_option_helpers(
        [
          Servactory::Maintenance::Attributes::OptionHelper.new(
            name: :must_be_6_characters,
            equivalent: {
              must: {
                be_6_characters: {
                  is: lambda do |value:, **|
                    value.all? do |id|
                      return true if id.blank? # NOTE: This is not the responsibility of this `must` validator

                      (id.is_a?(Integer) ? id.abs.digits.length : id.size) == 6
                    end
                  end,
                  message: lambda do |output:, **|
                    "Wrong IDs in `#{output.name}`"
                  end
                }
              }
            }
          ),
          Servactory::ToolKit::DynamicOptions::Format.use(
            formats: {
              email: {
                pattern: /@/,
                validator: ->(value:) { value.present? }
              }
            }
          ),
          Servactory::ToolKit::DynamicOptions::Min.use,
          Servactory::ToolKit::DynamicOptions::Max.use,
          Servactory::ToolKit::DynamicOptions::MultipleOf.use,
          Servactory::ToolKit::DynamicOptions::Target.use,
          ApplicationService::DynamicOptions::CustomEq.use
        ]
      )

      action_shortcuts(
        %i[assign],
        {
          restrict: {
            prefix: :create,
            suffix: :restriction
          }
        }
      )

      action_aliases %i[play do_it!]

      i18n_root_key :servactory

      predicate_methods_enabled true
    end
  end
end
