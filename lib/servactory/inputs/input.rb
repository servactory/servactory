# frozen_string_literal: true

module Servactory
  module Inputs
    class Input # rubocop:disable Metrics/ClassLength
      attr_reader :name,
                  :internal_name,
                  :option_helpers

      # rubocop:disable Style/KeywordParametersOrder
      def initialize(
        name,
        *helpers,
        as: nil,
        type:,
        option_helpers:,
        **options
      )
        @name = name
        @internal_name = as.present? ? as : name
        @option_helpers = option_helpers

        options = apply_helpers_for_options(helpers: helpers, options: options) if helpers.present?

        add_basic_options_with(type: type, options: options)
      end
      # rubocop:enable Style/KeywordParametersOrder

      def method_missing(name, *args, &block)
        option = collection_of_options.find_by(name: name)

        return super if option.nil?

        option.body
      end

      def respond_to_missing?(name, *)
        collection_of_options.names.include?(name) || super
      end

      def apply_helpers_for_options(helpers:, options:)
        prepared_options = {}

        helpers.each do |helper|
          found_helper = option_helpers.find_by(name: helper)

          next if found_helper.blank?

          prepared_options.merge!(found_helper.equivalent)
        end

        options.merge(prepared_options)
      end

      def add_basic_options_with(type:, options:)
        # Check Class: Servactory::Inputs::Validations::Required
        add_required_option_with(options)

        # Check Class: Servactory::Inputs::Validations::Type
        add_types_option_with(type)
        add_default_option_with(options)
        add_collection_option_with(options)

        # Check Class: Servactory::Inputs::Validations::Inclusion
        add_inclusion_option_with(options)

        # Check Class: Servactory::Inputs::Validations::Must
        add_must_option_with(options)

        # Check Class: nil
        add_prepare_option_with(options)
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
              content: ->(option:) { Servactory::Utils.true?(option[:is]) }
            ),
            DefineInputMethod.new(
              name: :optional?,
              content: ->(option:) { !Servactory::Utils.true?(option[:is]) }
            )
          ],
          define_input_conflicts: [
            DefineInputConflict.new(content: -> { :required_vs_default if required? && default_value_present? })
          ],
          need_for_checks: true,
          body_key: :is,
          body_fallback: true,
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
          body_fallback: nil,
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
              content: ->(option:) { !option.nil? }
            )
          ],
          need_for_checks: true,
          body_fallback: nil,
          with_advanced_mode: false,
          **options
        )
      end

      def add_collection_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Option.new(
          name: :of,
          input: self,
          validation_class: Servactory::Inputs::Validations::Type,
          define_input_methods: [
            DefineInputMethod.new(
              name: :collection_mode?,
              content: ->(option:) { option[:type].present? }
            )
          ],
          define_input_conflicts: [
            DefineInputConflict.new(content: -> { :collection_vs_inclusion if collection_mode? && inclusion_present? })
          ],
          need_for_checks: false,
          body_key: :type,
          body_value: String,
          body_fallback: false,
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
              content: ->(option:) { option[:in].is_a?(Array) && option[:in].present? }
            )
          ],
          need_for_checks: true,
          body_key: :in,
          body_fallback: nil,
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
              content: ->(option:) { option.present? }
            )
          ],
          need_for_checks: true,
          body_key: :is,
          body_fallback: nil,
          with_advanced_mode: false,
          **options
        )
      end

      def add_prepare_option_with(options) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        collection_of_options << Option.new(
          name: :prepare,
          input: self,
          validation_class: nil,
          define_input_methods: [
            DefineInputMethod.new(
              name: :prepare_present?,
              content: ->(option:) { option[:in].present? }
            )
          ],
          define_input_conflicts: [
            DefineInputConflict.new(content: -> { :prepare_vs_collection if prepare_present? && collection_mode? }),
            DefineInputConflict.new(content: -> { :prepare_vs_inclusion if prepare_present? && inclusion_present? }),
            DefineInputConflict.new(content: -> { :prepare_vs_must if prepare_present? && must_present? })
          ],
          need_for_checks: false,
          body_key: :in,
          body_fallback: false,
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
              content: ->(option:) { Servactory::Utils.true?(option[:is]) }
            )
          ],
          need_for_checks: false,
          body_key: :is,
          body_fallback: false,
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
