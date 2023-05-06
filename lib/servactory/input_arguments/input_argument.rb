# frozen_string_literal: true

module Servactory
  module InputArguments
    class InputArgument
      ARRAY_DEFAULT_VALUE = ->(is: false, message: nil) { { is: is, message: message } }

      attr_reader :name,
                  :collection_of_options,
                  :types

      def initialize(name, collection_of_options:, type:, **options)
        @name = name
        @collection_of_options = collection_of_options
        @types = Array(type)

        add_basic_options_with(options)

        @collection_of_options.each do |option|
          self.class.attr_reader(:"#{option.name}")

          instance_variable_set(:"@#{option.name}", option.value)
        end
      end

      def add_basic_options_with(options)
        # Check Class: Servactory::InputArguments::Checks::Required
        add_required_option_with(options)

        # Check Class: Servactory::InputArguments::Checks::Type
        add_array_option_with(options)
        add_default_option_with(options)

        # Check Class: Servactory::InputArguments::Checks::Inclusion
        add_inclusion_option_with(options)

        # Check Class: Servactory::InputArguments::Checks::Must
        add_must_option_with(options)

        # Check Class: nil
        add_internal_option_with(options)
      end

      def add_required_option_with(options)
        collection_of_options << Option.new(
          :required,
          check_class: Servactory::InputArguments::Checks::Required,
          need_for_checks: true,
          value_fallback: true,
          **options
        )
      end

      def add_array_option_with(options)
        collection_of_options << Option.new(
          :array,
          check_class: Servactory::InputArguments::Checks::Type,
          need_for_checks: false,
          value_fallback: false,
          **options
        )
      end

      def add_default_option_with(options)
        collection_of_options << Option.new(
          :default,
          check_class: Servactory::InputArguments::Checks::Type,
          need_for_checks: true,
          value_fallback: nil,
          with_advanced_mode: false,
          **options
        )
      end

      def add_inclusion_option_with(options)
        collection_of_options << Option.new(
          :inclusion,
          check_class: Servactory::InputArguments::Checks::Inclusion,
          need_for_checks: true,
          value_fallback: nil,
          **options
        )
      end

      def add_must_option_with(options)
        collection_of_options << Option.new(
          :must,
          check_class: Servactory::InputArguments::Checks::Must,
          need_for_checks: true,
          value_fallback: nil,
          with_advanced_mode: false,
          **options
        )
      end

      def add_internal_option_with(options)
        collection_of_options << Option.new(
          :internal,
          need_for_checks: false,
          check_class: nil,
          value_fallback: false,
          **options
        )
      end

      def options_for_checks
        {
          types: types
        }.merge(
          collection_of_options.options_for_checks
        )
      end

      def conflict_code
        return :required_vs_default if required? && default_value_present?
        return :array_vs_array if array? && types.include?(Array)
        return :array_vs_inclusion if array? && inclusion_present?

        nil
      end

      def inclusion_present?
        inclusion[:is].is_a?(Array) && inclusion[:is].present?
      end

      def must_present?
        must.present?
      end

      def array?
        Servactory::Utils.boolean?(array[:is])
      end

      def required?
        Servactory::Utils.boolean?(required[:is])
      end

      def optional?
        !required?
      end

      def internal?
        Servactory::Utils.boolean?(internal[:is])
      end

      def default_value_present?
        !default.nil?
      end

      def with_conflicts?
        conflict_code.present?
      end
    end
  end
end
