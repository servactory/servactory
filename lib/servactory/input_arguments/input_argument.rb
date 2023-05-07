# frozen_string_literal: true

module Servactory
  module InputArguments
    class InputArgument # rubocop:disable Metrics/ClassLength
      ARRAY_DEFAULT_VALUE = ->(is: false, message: nil) { { is: is, message: message } }

      attr_reader :name,
                  :collection_of_options

      def initialize(name, collection_of_options:, type:, **options)
        @name = name
        @collection_of_options = collection_of_options

        add_basic_options_with(type:, options:)

        @collection_of_options.each do |option|
          self.class.attr_reader(:"#{option.name}")

          instance_variable_set(:"@#{option.name}", option.value)
        end
      end

      def add_basic_options_with(type:, options:)
        # Check Class: Servactory::InputArguments::Checks::Required
        add_required_option_with(options)

        # Check Class: Servactory::InputArguments::Checks::Type
        add_types_option_with(type)
        add_default_option_with(options)
        add_array_option_with(options)

        # Check Class: Servactory::InputArguments::Checks::Inclusion
        add_inclusion_option_with(options)

        # Check Class: Servactory::InputArguments::Checks::Must
        add_must_option_with(options)

        # Check Class: nil
        add_internal_option_with(options)
      end

      def add_required_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :required,
          input: self,
          check_class: Servactory::InputArguments::Checks::Required,
          define_input_methods: lambda do
            <<-RUBY
              def required?
                Servactory::Utils.boolean?(required[:is])
              end

              def optional?
                !required?
              end
            RUBY
          end,
          define_conflicts: lambda do
            <<-RUBY
              return :required_vs_default if required? && default_value_present?
            RUBY
          end,
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
          original_value: Array(type),
          check_class: Servactory::InputArguments::Checks::Type,
          need_for_checks: true,
          value_fallback: nil,
          with_advanced_mode: false
        )
      end

      def add_default_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :default,
          input: self,
          check_class: Servactory::InputArguments::Checks::Type,
          define_input_methods: lambda do
            <<-RUBY
              def default_value_present?
                !default.nil?
              end
            RUBY
          end,
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
          check_class: Servactory::InputArguments::Checks::Type,
          define_input_methods: lambda do
            <<-RUBY
              def array?
                Servactory::Utils.boolean?(array[:is])
              end
            RUBY
          end,
          define_conflicts: lambda do
            <<-RUBY
              return :array_vs_array if array? && types.include?(Array)
              return :array_vs_inclusion if array? && inclusion_present?
            RUBY
          end,
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
          check_class: Servactory::InputArguments::Checks::Inclusion,
          define_input_methods: lambda do
            <<-RUBY
              def inclusion_present?
                inclusion[:in].is_a?(Array) && inclusion[:in].present?
              end
            RUBY
          end,
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
          check_class: Servactory::InputArguments::Checks::Must,
          define_input_methods: lambda do
            <<-RUBY
              def must_present?
                must.present?
              end
            RUBY
          end,
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
          define_input_methods: lambda do
            <<-RUBY
              def internal?
                Servactory::Utils.boolean?(internal[:is])
              end
            RUBY
          end,
          need_for_checks: false,
          check_class: nil,
          value_key: :is,
          value_fallback: false,
          **options
        )
      end

      def options_for_checks
        collection_of_options.options_for_checks
      end

      def conflict_code
        instance_eval(collection_of_options.defined_conflicts)

        nil
      end

      def with_conflicts?
        conflict_code.present?
      end
    end
  end
end
