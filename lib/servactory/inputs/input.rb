# frozen_string_literal: true

module Servactory
  module Inputs
    class Input # rubocop:disable Metrics/ClassLength
      ARRAY_DEFAULT_VALUE = ->(is: false, message: nil) { { is: is, message: message } }

      HELPER_LIBRARY = {
        required: { required: true },
        internal: { internal: true },
        as_array: { array: true }
      }.freeze

      private_constant :HELPER_LIBRARY

      attr_reader :name,
                  :internal_name

      # rubocop:disable Style/KeywordParametersOrder
      def initialize(
        name,
        *helpers,
        as: nil,
        type:,
        **options
      )
        @name = name
        @internal_name = as.present? ? as : name

        options = apply_helpers_for_options(helpers: helpers, options: options)

        add_basic_options_with(type: type, options: options)

        collection_of_options.each do |option|
          self.class.attr_reader(:"#{option.name}")

          instance_variable_set(:"@#{option.name}", option.value)
        end
      end
      # rubocop:enable Style/KeywordParametersOrder

      def apply_helpers_for_options(helpers:, options:)
        prepared_options = {}

        helpers.each do |helper|
          next unless HELPER_LIBRARY.key?(helper)

          found_helper = HELPER_LIBRARY[helper]

          prepared_options.merge!(found_helper)
        end

        options.merge(prepared_options)
      end

      def add_basic_options_with(type:, options:)
        # Check Class: Servactory::Inputs::Validations::Required
        add_required_option_with(options)

        # Check Class: Servactory::Inputs::Validations::Type
        add_types_option_with(type)
        add_default_option_with(options)
        add_array_option_with(options)

        # Check Class: Servactory::Inputs::Validations::Inclusion
        add_inclusion_option_with(options)

        # Check Class: Servactory::Inputs::Validations::Must
        add_must_option_with(options)

        # Check Class: nil
        add_internal_option_with(options)
      end

      def add_required_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :required,
          input: self,
          validation_class: Servactory::Inputs::Validations::Required,
          define_input_methods: [
            DefineInputMethod.new(
              name: :required?,
              content: ->(value:) { Servactory::Utils.true?(value[:is]) }
            ),
            DefineInputMethod.new(
              name: :optional?,
              content: ->(value:) { !Servactory::Utils.true?(value[:is]) }
            )
          ],
          define_input_conflicts: [
            DefineInputConflict.new(content: -> { :required_vs_default if required? && default_value_present? })
          ],
          need_for_checks: true,
          value_key: :is,
          value_fallback: true,
          **options
        )
      end

      def add_types_option_with(type)
        collection_of_options << Option.new(
          name: :types,
          input: self,
          validation_class: Servactory::Inputs::Validations::Type,
          original_value: Array(type),
          need_for_checks: true,
          value_fallback: nil,
          with_advanced_mode: false
        )
      end

      def add_default_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :default,
          input: self,
          validation_class: Servactory::Inputs::Validations::Type,
          define_input_methods: [
            DefineInputMethod.new(
              name: :default_value_present?,
              content: ->(value:) { !value.nil? }
            )
          ],
          need_for_checks: true,
          value_fallback: nil,
          with_advanced_mode: false,
          **options
        )
      end

      def add_array_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :array,
          input: self,
          validation_class: Servactory::Inputs::Validations::Type,
          define_input_methods: [
            DefineInputMethod.new(
              name: :array?,
              content: ->(value:) { Servactory::Utils.true?(value[:is]) }
            )
          ],
          define_input_conflicts: [
            DefineInputConflict.new(content: -> { :array_vs_array if array? && types.include?(Array) }),
            DefineInputConflict.new(content: -> { :array_vs_inclusion if array? && inclusion_present? })
          ],
          need_for_checks: false,
          value_key: :is,
          value_fallback: false,
          **options
        )
      end

      def add_inclusion_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :inclusion,
          input: self,
          validation_class: Servactory::Inputs::Validations::Inclusion,
          define_input_methods: [
            DefineInputMethod.new(
              name: :inclusion_present?,
              content: ->(value:) { value[:in].is_a?(Array) && value[:in].present? }
            )
          ],
          need_for_checks: true,
          value_key: :in,
          value_fallback: nil,
          **options
        )
      end

      def add_must_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :must,
          input: self,
          validation_class: Servactory::Inputs::Validations::Must,
          define_input_methods: [
            DefineInputMethod.new(
              name: :must_present?,
              content: ->(value:) { value.present? }
            )
          ],
          need_for_checks: true,
          value_key: :is,
          value_fallback: nil,
          with_advanced_mode: false,
          **options
        )
      end

      def add_internal_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :internal,
          input: self,
          validation_class: nil,
          define_input_methods: [
            DefineInputMethod.new(
              name: :internal?,
              content: ->(value:) { Servactory::Utils.true?(value[:is]) }
            )
          ],
          need_for_checks: false,
          value_key: :is,
          value_fallback: false,
          **options
        )
      end

      def collection_of_options
        @collection_of_options ||= OptionsCollection.new
      end

      def options_for_checks
        collection_of_options.options_for_checks
      end

      def conflict_code
        collection_of_options.defined_conflict_code
      end

      def with_conflicts?
        conflict_code.present?
      end
    end
  end
end
