# frozen_string_literal: true

module Servactory
  class Configuration
    # attr_accessor :input_exception_class,
    #               :internal_exception_class,
    #               :output_exception_class,
    #               :success_class,
    #               :failure_class,
    #               :result_class,
    #               :collection_mode_class_names,
    #               :hash_mode_class_names,
    #               :input_option_helpers,
    #               :internal_option_helpers,
    #               :output_option_helpers,
    #               :action_aliases,
    #               :action_shortcuts,
    #               :i18n_root_key,
    #               :predicate_methods_enabled

    def initialize(domain)
      @domain = domain

      # @input_exception_class = Servactory::Exceptions::Input
      # @internal_exception_class = Servactory::Exceptions::Internal
      # @output_exception_class = Servactory::Exceptions::Output
      #
      # @success_class = Servactory::Exceptions::Success
      # @failure_class = Servactory::Exceptions::Failure
      #
      # @result_class = Servactory::Result
      #
      # @collection_mode_class_names =
      #   Servactory::OldConfiguration::CollectionMode::ClassNamesCollection.new(default_collection_mode_class_names)
      #
      # @hash_mode_class_names =
      #   Servactory::OldConfiguration::HashMode::ClassNamesCollection.new(default_hash_mode_class_names)
      #
      # @input_option_helpers =
      #   Servactory::OldConfiguration::OptionHelpers::OptionHelpersCollection.new(default_input_option_helpers)
      # @internal_option_helpers =
      #   Servactory::OldConfiguration::OptionHelpers::OptionHelpersCollection.new(default_internal_option_helpers)
      # @output_option_helpers =
      #   Servactory::OldConfiguration::OptionHelpers::OptionHelpersCollection.new(default_output_option_helpers)
      #
      # @action_aliases = Servactory::OldConfiguration::Actions::Aliases::Collection.new
      #
      # @action_shortcuts = Servactory::OldConfiguration::Actions::Shortcuts::Collection.new
      #
      # @action_rescue_handlers = Servactory::OldConfiguration::Actions::RescueHandlers::Collection.new
      #
      # @i18n_root_key = nil
      #
      # @predicate_methods_enabled = nil
    end

    def store
      @store ||= {
        @domain => {
          input_exception_class: Servactory::Exceptions::Input,
          internal_exception_class: Servactory::Exceptions::Internal,
          output_exception_class: Servactory::Exceptions::Output,
          success_class: Servactory::Exceptions::Success,
          failure_class: Servactory::Exceptions::Failure,
          result_class: Servactory::Result,
          collection_mode_class_names:
            Servactory::OldConfiguration::CollectionMode::ClassNamesCollection.new(default_collection_mode_class_names),
          hash_mode_class_names:
            Servactory::OldConfiguration::HashMode::ClassNamesCollection.new(default_hash_mode_class_names),
          input_option_helpers:
            Servactory::OldConfiguration::OptionHelpers::OptionHelpersCollection.new(default_input_option_helpers),
          internal_option_helpers:
            Servactory::OldConfiguration::OptionHelpers::OptionHelpersCollection.new(default_internal_option_helpers),
          output_option_helpers:
            Servactory::OldConfiguration::OptionHelpers::OptionHelpersCollection.new(default_output_option_helpers),
          action_shortcuts: Servactory::OldConfiguration::Actions::Aliases::Collection.new,
          action_aliases: Servactory::OldConfiguration::Actions::Aliases::Collection.new,
          i18n_root_key: :servactory,
          predicate_methods_enabled: true
        }
      }
    end

    def input_exception_class=(value)
      raise_error_about_wrong_exception_class_with(:input_exception_class, value) unless subclass_of_exception?(value)

      store.fetch(@domain).merge(:input_exception_class, value)
    end

    def input_exception_class
      store.fetch(@domain).fetch(:input_exception_class)
    end

    def collection_mode_class_names
      store.fetch(@domain).fetch(:collection_mode_class_names)
    end

    private

    def default_collection_mode_class_names
      Set[Array, Set]
    end

    def default_hash_mode_class_names
      Set[Hash]
    end

    def default_input_option_helpers
      Set[
        Servactory::Maintenance::Attributes::OptionHelper.new(name: :optional, equivalent: { required: false }),
        Servactory::ToolKit::DynamicOptions::ConsistsOf.use(collection_mode_class_names:),
        Servactory::ToolKit::DynamicOptions::Schema.use(default_hash_mode_class_names:),
        Servactory::ToolKit::DynamicOptions::Inclusion.use
      ]
    end

    def default_internal_option_helpers
      Set[
        Servactory::ToolKit::DynamicOptions::ConsistsOf.use(collection_mode_class_names:),
        Servactory::ToolKit::DynamicOptions::Schema.use(default_hash_mode_class_names:),
        Servactory::ToolKit::DynamicOptions::Inclusion.use
      ]
    end

    def default_output_option_helpers
      Set[
        Servactory::ToolKit::DynamicOptions::ConsistsOf.use(collection_mode_class_names:),
        Servactory::ToolKit::DynamicOptions::Schema.use(default_hash_mode_class_names:),
        Servactory::ToolKit::DynamicOptions::Inclusion.use
      ]
    end

    ##########################################################################

    def subclass_of_exception?(value)
      value.is_a?(Class) && value <= Exception
    end

    ##########################################################################

    def raise_error_about_wrong_exception_class_with(config_name, value)
      raise ArgumentError,
            "Error in `#{config_name}` configuration. " \
              "The `#{value}` value must be a subclass of `Exception`. " \
              "See configuration example here: https://servactory.com/guide/configuration"
    end
  end
end
