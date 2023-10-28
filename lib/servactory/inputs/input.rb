# frozen_string_literal: true

module Servactory
  module Inputs
    class Input # rubocop:disable Metrics/ClassLength
      attr_accessor :value

      attr_reader :name,
                  :internal_name,
                  :collection_mode_class_names,
                  :hash_mode_class_names,
                  :option_helpers

      # rubocop:disable Style/KeywordParametersOrder
      def initialize(
        name,
        *helpers,
        as: nil,
        type:,
        collection_mode_class_names:,
        hash_mode_class_names:,
        option_helpers:,
        **options
      )
        @name = name
        @internal_name = as.present? ? as : name
        @collection_mode_class_names = collection_mode_class_names
        @hash_mode_class_names = hash_mode_class_names
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
        add_collection_option_with(type, options)
        add_hash_option_with(type, options)

        # Check Class: Servactory::Inputs::Validations::Inclusion
        add_inclusion_option_with(options)

        # Check Class: Servactory::Inputs::Validations::Must
        add_must_option_with(options)

        # Check Class: nil
        add_prepare_option_with(options)
      end

      def add_required_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Servactory::Maintenance::Attributes::Option.new(
          name: :required,
          attribute: self,
          validation_class: Servactory::Inputs::Validations::Required,
          define_methods: [
            Servactory::Maintenance::Attributes::DefineMethod.new(
              name: :required?,
              content: ->(option:) { Servactory::Utils.true?(option[:is]) }
            ),
            Servactory::Maintenance::Attributes::DefineMethod.new(
              name: :optional?,
              content: ->(option:) { !Servactory::Utils.true?(option[:is]) }
            )
          ],
          define_conflicts: [
            Servactory::Maintenance::Attributes::DefineConflict.new(
              content: -> { :required_vs_default if required? && default_value_present? }
            )
          ],
          need_for_checks: true,
          body_key: :is,
          body_fallback: true,
          **options
        )
      end

      def add_types_option_with(type)
        collection_of_options << Servactory::Maintenance::Attributes::Option.new(
          name: :types,
          attribute: self,
          validation_class: Servactory::Inputs::Validations::Type,
          original_value: Array(type),
          need_for_checks: true,
          body_fallback: nil,
          with_advanced_mode: false
        )
      end

      def add_default_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Servactory::Maintenance::Attributes::Option.new(
          name: :default,
          attribute: self,
          validation_class: Servactory::Inputs::Validations::Type,
          define_methods: [
            Servactory::Maintenance::Attributes::DefineMethod.new(
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

      def add_collection_option_with(type, options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Servactory::Maintenance::Attributes::Option.new(
          name: :consists_of,
          attribute: self,
          validation_class: Servactory::Inputs::Validations::Type,
          define_methods: [
            Servactory::Maintenance::Attributes::DefineMethod.new(
              name: :collection_mode?,
              content: ->(**) { collection_mode_class_names.include?(type) }
            )
          ],
          define_conflicts: [
            Servactory::Maintenance::Attributes::DefineConflict.new(
              content: -> { :collection_vs_inclusion if collection_mode? && inclusion_present? }
            )
          ],
          need_for_checks: false,
          body_key: :type,
          body_value: String,
          body_fallback: String,
          **options
        )
      end

      def add_hash_option_with(type, options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Servactory::Maintenance::Attributes::Option.new(
          name: :schema,
          attribute: self,
          validation_class: Servactory::Inputs::Validations::Type,
          define_methods: [
            Servactory::Maintenance::Attributes::DefineMethod.new(
              name: :hash_mode?,
              content: ->(**) { hash_mode_class_names.include?(type) }
            )
          ],
          define_conflicts: [
            Servactory::Maintenance::Attributes::DefineConflict.new(
              content: -> { :object_vs_inclusion if hash_mode? && inclusion_present? }
            )
          ],
          need_for_checks: false,
          body_fallback: {},
          with_advanced_mode: false,
          **options
        )
      end

      def add_inclusion_option_with(options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Servactory::Maintenance::Attributes::Option.new(
          name: :inclusion,
          attribute: self,
          validation_class: Servactory::Inputs::Validations::Inclusion,
          define_methods: [
            Servactory::Maintenance::Attributes::DefineMethod.new(
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
        collection_of_options << Servactory::Maintenance::Attributes::Option.new(
          name: :must,
          attribute: self,
          validation_class: Servactory::Inputs::Validations::Must,
          define_methods: [
            Servactory::Maintenance::Attributes::DefineMethod.new(
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
        collection_of_options << Servactory::Maintenance::Attributes::Option.new(
          name: :prepare,
          attribute: self,
          validation_class: nil,
          define_methods: [
            Servactory::Maintenance::Attributes::DefineMethod.new(
              name: :prepare_present?,
              content: ->(option:) { option[:in].present? }
            )
          ],
          define_conflicts: [
            Servactory::Maintenance::Attributes::DefineConflict.new(
              content: -> { :prepare_vs_collection if prepare_present? && collection_mode? }
            ),
            Servactory::Maintenance::Attributes::DefineConflict.new(
              content: -> { :prepare_vs_inclusion if prepare_present? && inclusion_present? }
            ),
            Servactory::Maintenance::Attributes::DefineConflict.new(
              content: -> { :prepare_vs_must if prepare_present? && must_present? }
            )
          ],
          need_for_checks: false,
          body_key: :in,
          body_fallback: false,
          **options
        )
      end

      def collection_of_options
        @collection_of_options ||= Servactory::Maintenance::Attributes::OptionsCollection.new
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
