# frozen_string_literal: true

module Servactory
  module Inputs
    class Input # rubocop:disable Metrics/ClassLength
      ARRAY_DEFAULT_VALUE = ->(is: false, message: nil) { { is: is, message: message } }

      attr_reader :name,
                  :internal_name

      # rubocop:disable Style/KeywordParametersOrder
      def initialize(
        name,
        as: nil,
        type:,
        **options
      )
        @name = name
        @internal_name = as.present? ? as : name

        add_basic_options_with(type: type, options: options)

        collection_of_options.each do |option|
          self.class.attr_reader(:"#{option.name}")

          instance_variable_set(:"@#{option.name}", option.value)
        end
      end
      # rubocop:enable Style/KeywordParametersOrder

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
          check_class: Servactory::Inputs::Validations::Required,
          define_input_methods: [
            DefineInputMethod.new(
              name: :required?,
              content: ->(value:) { Servactory::Utils.boolean?(value[:is]) }
            ),
            DefineInputMethod.new(
              name: :optional?,
              content: ->(value:) { !Servactory::Utils.boolean?(value[:is]) }
            )
          ],
          define_input_conflicts: [
            DefineInputConflict.new(content: -> { return :required_vs_default if required? && default_value_present? })
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
          check_class: Servactory::Inputs::Validations::Type,
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
          check_class: Servactory::Inputs::Validations::Type,
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
          check_class: Servactory::Inputs::Validations::Type,
          define_input_methods: [
            DefineInputMethod.new(
              name: :array?,
              content: ->(value:) { Servactory::Utils.boolean?(value[:is]) }
            )
          ],
          define_input_conflicts: [
            DefineInputConflict.new(content: -> { return :array_vs_array if array? && types.include?(Array) }),
            DefineInputConflict.new(content: -> { return :array_vs_inclusion if array? && inclusion_present? })
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
          check_class: Servactory::Inputs::Validations::Inclusion,
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
          check_class: Servactory::Inputs::Validations::Must,
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
          check_class: nil,
          define_input_methods: [
            DefineInputMethod.new(
              name: :internal?,
              content: ->(value:) { Servactory::Utils.boolean?(value[:is]) }
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
