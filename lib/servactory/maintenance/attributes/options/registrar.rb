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
            must
            prepare
          ].freeze

          DEFAULT_FEATURES = {
            required: false,
            types: false,
            default: false,
            must: false,
            prepare: false
          }.freeze

          private_constant :DEFAULT_FEATURES

          def self.register(...)
            new(...).register
          end

          def initialize(attribute:, options:, features:)
            @attribute = attribute
            @options = options
            @features = DEFAULT_FEATURES.merge(features)
          end

          ########################################################################

          def register
            # Validation Class: Servactory::Inputs::Validations::Required
            register_required_option if @features.fetch(:required)

            # Validation Class: Servactory::Maintenance::Attributes::Validations::Type
            register_types_option if @features.fetch(:types)
            register_default_option if @features.fetch(:default)

            # Validation Class: Servactory::Maintenance::Attributes::Validations::Must
            register_must_option if @features.fetch(:must)

            # Validation Class: nil
            register_prepare_option if @features.fetch(:prepare)

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
              need_for_checks: false,
              body_key: :in,
              body_fallback: false,
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
