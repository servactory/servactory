# frozen_string_literal: true

module Servactory
  module InputArguments
    class InputArgument # rubocop:disable Metrics/ClassLength
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

      def add_required_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :required,
          input: self,
          check_class: Servactory::InputArguments::Checks::Required,
          instance_eval: lambda do
            <<-RUBY
              def required?
                Servactory::Utils.boolean?(required[:is])
              end

              def optional?
                !required?
              end
            RUBY
          end,
          need_for_checks: true,
          value_fallback: true,
          **options
        )
      end

      def add_array_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :array,
          input: self,
          check_class: Servactory::InputArguments::Checks::Type,
          instance_eval: lambda do
            <<-RUBY
              def array?
                Servactory::Utils.boolean?(array[:is])
              end
            RUBY
          end,
          need_for_checks: false,
          value_fallback: false,
          **options
        )
      end

      def add_default_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :default,
          input: self,
          check_class: Servactory::InputArguments::Checks::Type,
          instance_eval: lambda do
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

      def add_inclusion_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :inclusion,
          input: self,
          check_class: Servactory::InputArguments::Checks::Inclusion,
          instance_eval: lambda do
            <<-RUBY
              def inclusion_present?
                inclusion[:is].is_a?(Array) && inclusion[:is].present?
              end
            RUBY
          end,
          need_for_checks: true,
          value_fallback: nil,
          **options
        )
      end

      def add_must_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :must,
          input: self,
          check_class: Servactory::InputArguments::Checks::Must,
          instance_eval: lambda do
            <<-RUBY
              def must_present?
                must.present?
              end
            RUBY
          end,
          need_for_checks: true,
          value_fallback: nil,
          with_advanced_mode: false,
          **options
        )
      end

      def add_internal_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :internal,
          input: self,
          instance_eval: lambda do
            <<-RUBY
              def internal?
                Servactory::Utils.boolean?(internal[:is])
              end
            RUBY
          end,
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

      def with_conflicts?
        conflict_code.present?
      end
    end
  end
end
