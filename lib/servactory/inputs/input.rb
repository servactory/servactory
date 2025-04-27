# frozen_string_literal: true

module Servactory
  module Inputs
    class Input # rubocop:disable Metrics/ClassLength
      class Actor
        attr_reader :name,
                    :internal_name,
                    :types,
                    :default,
                    :options

        def initialize(input)
          @name = input.name
          @internal_name = input.internal_name
          @types = input.types
          @default = input.default
          @options = input.options

          define_identity_methods(input)
        end

        private

        def define_identity_methods(input) # rubocop:disable Metrics/MethodLength
          methods_map = {
            system_name: -> { input.system_name },
            i18n_name: -> { input.i18n_name },
            optional?: -> { input.optional? },
            required?: -> { input.required? },
            # The methods below are required to support the internal work.
            input?: -> { true },
            internal?: -> { false },
            output?: -> { false }
          }

          methods_map.each do |method_name, implementation|
            define_singleton_method(method_name, &implementation)
          end
        end
      end

      attr_reader :name,
                  :internal_name,
                  :collection_of_options,
                  :options

      # rubocop:disable Style/KeywordParametersOrder
      def initialize(
        name,
        *helpers,
        as: nil,
        option_helpers:,
        **options
      )
        @name = name
        @internal_name = as.presence || name
        @option_helpers = option_helpers

        register_options(helpers:, options:)
      end
      # rubocop:enable Style/KeywordParametersOrder

      def method_missing(name, *args, &block)
        option = @collection_of_options.find_by(name:)
        return super if option.nil?

        option.body
      end

      def respond_to_missing?(name, *)
        @collection_of_options.names.include?(name) || super
      end

      def register_options(helpers:, options:)
        merged_options = augment_options_with_helpers(helpers:, options:)
        options_registrar = create_options_registrar(options: merged_options)

        @options = merged_options
        @collection_of_options = options_registrar.collection
      end

      def options_for_checks
        @collection_of_options.options_for_checks
      end

      def conflict_code
        @collection_of_options.defined_conflict_code
      end

      def system_name
        self.class.name.demodulize.downcase.to_sym
      end

      def i18n_name
        system_name.to_s.pluralize
      end

      def with_conflicts?
        conflict_code.present?
      end

      def input?
        true
      end

      def internal?
        false
      end

      def output?
        false
      end

      private

      def create_options_registrar(options:)
        Servactory::Maintenance::Attributes::Options::Registrar.register(
          attribute: self,
          options:,
          features: available_feature_options
        )
      end

      def available_feature_options
        {
          required: true,
          types: true,
          default: true,
          must: true,
          prepare: true
        }
      end

      def augment_options_with_helpers(helpers:, options:)
        result_options = options.dup
        merge_standard_helpers_into(target_options: result_options, helpers:) if helpers.present?
        merge_advanced_helpers_into(target_options: result_options, source_options: options)
        result_options
      end

      def merge_standard_helpers_into(target_options:, helpers:)
        standard_helpers_result = transform_helpers_to_options(helpers:)
        target_options.deep_merge!(standard_helpers_result)
      end

      def merge_advanced_helpers_into(target_options:, source_options:)
        advanced_helpers = filter_advanced_helpers(options: source_options)
        return if advanced_helpers.blank?

        advanced_helpers_result = transform_helpers_to_options(helpers: advanced_helpers)
        target_options.deep_merge!(advanced_helpers_result)
      end

      def filter_advanced_helpers(options:)
        reserved_options = Servactory::Maintenance::Attributes::Options::Registrar::RESERVED_OPTIONS
        options.except(*reserved_options)
      end

      def transform_helpers_to_options(helpers:)
        helpers.each_with_object({}) do |(helper_name, values), result|
          helper = @option_helpers.find_by(name: helper_name)
          next if helper.blank?

          transformed_option = transform_helper_to_option(helper:, values:)
          result.deep_merge!(transformed_option) if transformed_option.present?
        end
      end

      def transform_helper_to_option(helper:, values:)
        return helper.equivalent unless helper.equivalent.is_a?(Proc)

        if values.is_a?(Hash)
          helper.equivalent.call(**values)
        else
          helper.equivalent.call(values)
        end
      end
    end
  end
end
