# frozen_string_literal: true

module Servactory
  module InputArguments
    class InputArgument
      ARRAY_DEFAULT_VALUE = ->(is: false, message: nil) { { is: is, message: message } }

      attr_reader :name,
                  :types

      def initialize(name, collection_of_options:, type:, **options)
        @name = name
        @types = Array(type)

        add_basic_options_to(collection_of_options, options)

        collection_of_options.each do |option|
          self.class.attr_reader(:"#{option.name}")

          instance_variable_set(:"@#{option.name}", option.value)
        end

        # @inclusion = options.fetch(:inclusion, nil)
        # @must = options.fetch(:must, nil)
        # @array = prepare_advanced_for(options.fetch(:array, ARRAY_DEFAULT_VALUE.call))
        # @required = options.fetch(:required, true)
        # @internal = options.fetch(:internal, false)
        # @default = options.fetch(:default, nil)
      end

      def add_basic_options_to(collection_of_options, options)
        add_required_option_to(collection_of_options, options)

        add_array_option_to(collection_of_options, options)
        add_default_option_to(collection_of_options, options)

        add_inclusion_option_to(collection_of_options, options)
        add_must_option_to(collection_of_options, options)

        add_internal_option_to(collection_of_options, options)
      end

      def add_required_option_to(collection_of_options, options)
        collection_of_options << Option.new(
          :required,
          check_class: Servactory::InputArguments::Checks::Required,
          **options,
          value_fallback: true
        )
      end

      def add_array_option_to(collection_of_options, options)
        collection_of_options << Option.new(
          :array,
          check_class: Servactory::InputArguments::Checks::Type,
          **options,
          value_fallback: false
        )
      end

      def add_default_option_to(collection_of_options, options)
        collection_of_options << Option.new(
          :default,
          check_class: Servactory::InputArguments::Checks::Type,
          **options,
          value_fallback: nil,
          with_advanced_mode: false
        )
      end

      def add_inclusion_option_to(collection_of_options, options)
        collection_of_options << Option.new(
          :inclusion,
          check_class: Servactory::InputArguments::Checks::Inclusion,
          **options,
          value_fallback: nil
        )
      end

      def add_must_option_to(collection_of_options, options)
        collection_of_options << Option.new(
          :must,
          check_class: Servactory::InputArguments::Checks::Must,
          **options,
          value_fallback: nil,
          with_advanced_mode: false
        )
      end

      def add_internal_option_to(collection_of_options, options)
        collection_of_options << Option.new(
          :internal,
          check_class: nil,
          **options,
          value_fallback: false
        )
      end














      def options_for_checks
        {
          types: types,
          inclusion: inclusion,
          must: must,
          required: required,
          # internal: internal,
          default: default
        }
      end

      # def prepare_advanced_for(value)
      #   if value.is_a?(Hash)
      #     ARRAY_DEFAULT_VALUE.call(
      #       is: value.fetch(:is, false),
      #       message: value.fetch(:message, nil)
      #     )
      #   else
      #     ARRAY_DEFAULT_VALUE.call(is: value)
      #   end
      # end

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
