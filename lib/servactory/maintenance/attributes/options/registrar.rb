# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Options
        class Registrar # rubocop:disable Metrics/ClassLength
          RESERVED_OPTIONS = %i[
            type
            required
            default
            collection
            hash
            inclusion
            must
            prepare
            note
          ].freeze

          DEFAULT_FEATURES = {
            required: false,
            types: false,
            default: false,
            hash: false,
            inclusion: false,
            must: false,
            prepare: false,
            note: false
          }.freeze

          private_constant :DEFAULT_FEATURES

          def self.register(...)
            new(...).register
          end

          def initialize(attribute:, hash_mode_class_names:, options:, features:)
            @attribute = attribute
            @hash_mode_class_names = hash_mode_class_names
            @options = options
            @features = DEFAULT_FEATURES.merge(features)
          end

          ########################################################################

          def register # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
            # Validation Class: Servactory::Inputs::Validations::Required
            register_required_option if @features.fetch(:required)

            # Validation Class: Servactory::Maintenance::Attributes::Validations::Type
            register_types_option if @features.fetch(:types)
            register_default_option if @features.fetch(:default)
            register_hash_option if @features.fetch(:hash)

            # Validation Class: Servactory::Maintenance::Attributes::Validations::Inclusion
            register_inclusion_option if @features.fetch(:inclusion)

            # Validation Class: Servactory::Maintenance::Attributes::Validations::Must
            register_must_option if @features.fetch(:must)

            # Validation Class: nil
            register_prepare_option if @features.fetch(:prepare)
            register_note_option if @features.fetch(:note)

            self
          end

          ########################################################################

          def register_required_option # rubocop:disable Metrics/MethodLength
            collection << Servactory::Maintenance::Attributes::Option.new(
              name: :required,
              attribute: @attribute,
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
                  content: -> { :required_vs_default if @attribute.required? && @attribute.default_value_present? }
                )
              ],
              need_for_checks: true,
              body_key: :is,
              body_fallback: true,
              **@options
            )
          end

          def register_types_option
            collection << Servactory::Maintenance::Attributes::Option.new(
              name: :types,
              attribute: @attribute,
              validation_class: Servactory::Maintenance::Attributes::Validations::Type,
              original_value: Array(@options.fetch(:type)).uniq,
              need_for_checks: true,
              body_fallback: nil,
              with_advanced_mode: false
            )
          end

          def register_default_option # rubocop:disable Metrics/MethodLength
            collection << Servactory::Maintenance::Attributes::Option.new(
              name: :default,
              attribute: @attribute,
              validation_class: Servactory::Maintenance::Attributes::Validations::Type,
              define_methods: [
                Servactory::Maintenance::Attributes::DefineMethod.new(
                  name: :default_value_present?,
                  content: ->(option:) { !option.nil? }
                )
              ],
              need_for_checks: true,
              body_fallback: nil,
              with_advanced_mode: false,
              **@options
            )
          end

          def register_hash_option # rubocop:disable Metrics/MethodLength
            collection << Servactory::Maintenance::Attributes::Option.new(
              name: :schema,
              attribute: @attribute,
              validation_class: Servactory::Maintenance::Attributes::Validations::Type,
              define_methods: [
                Servactory::Maintenance::Attributes::DefineMethod.new(
                  name: :hash_mode?,
                  content: ->(**) { @hash_mode_class_names.include?(@options.fetch(:type)) }
                )
              ],
              define_conflicts: [
                Servactory::Maintenance::Attributes::DefineConflict.new(
                  content: -> { :object_vs_inclusion if @attribute.hash_mode? && @attribute.inclusion_present? }
                )
              ],
              need_for_checks: false,
              body_key: :is,
              body_fallback: {},
              **@options
            )
          end

          def register_inclusion_option # rubocop:disable Metrics/MethodLength
            collection << Servactory::Maintenance::Attributes::Option.new(
              name: :inclusion,
              attribute: @attribute,
              validation_class: Servactory::Maintenance::Attributes::Validations::Inclusion,
              define_methods: [
                Servactory::Maintenance::Attributes::DefineMethod.new(
                  name: :inclusion_present?,
                  content: ->(option:) { option[:in].is_a?(Array) && option[:in].present? }
                )
              ],
              need_for_checks: true,
              body_key: :in,
              body_fallback: nil,
              **@options
            )
          end

          def register_must_option # rubocop:disable Metrics/MethodLength
            collection << Servactory::Maintenance::Attributes::Option.new(
              name: :must,
              attribute: @attribute,
              validation_class: Servactory::Maintenance::Attributes::Validations::Must,
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
              **@options
            )
          end

          def register_prepare_option # rubocop:disable Metrics/MethodLength
            collection << Servactory::Maintenance::Attributes::Option.new(
              name: :prepare,
              attribute: @attribute,
              validation_class: nil,
              define_methods: [
                Servactory::Maintenance::Attributes::DefineMethod.new(
                  name: :prepare_present?,
                  content: ->(option:) { option[:in].present? }
                )
              ],
              define_conflicts: [
                Servactory::Maintenance::Attributes::DefineConflict.new(
                  content: -> { :prepare_vs_inclusion if @attribute.prepare_present? && @attribute.inclusion_present? }
                )
              ],
              need_for_checks: false,
              body_key: :in,
              body_fallback: false,
              **@options
            )
          end

          def register_note_option # rubocop:disable Metrics/MethodLength
            collection << Servactory::Maintenance::Attributes::Option.new(
              name: :note,
              attribute: @attribute,
              validation_class: nil,
              define_methods: [
                Servactory::Maintenance::Attributes::DefineMethod.new(
                  name: :note_present?,
                  content: ->(option:) { option.present? }
                )
              ],
              need_for_checks: false,
              body_key: :is,
              body_fallback: nil,
              with_advanced_mode: false,
              **@options
            )
          end

          ########################################################################

          def collection
            @collection ||= Servactory::Maintenance::Attributes::OptionsCollection.new
          end
        end
      end
    end
  end
end
