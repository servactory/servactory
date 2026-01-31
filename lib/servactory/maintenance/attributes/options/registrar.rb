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
            register_feature(:required, Servactory::Inputs::Validations::Required)
            register_feature(:types, Servactory::Maintenance::Attributes::Validations::Type)
            register_feature(:default, Servactory::Maintenance::Attributes::Validations::Type)
            register_feature(:must, Servactory::Maintenance::Attributes::Validations::Must)
            register_feature(:prepare, nil)

            self
          end

          def collection
            @collection ||= Servactory::Maintenance::Attributes::OptionsCollection.new
          end

          private

          def register_feature(feature_name, validation_class)
            return unless @features.fetch(feature_name)

            method_name = "register_#{feature_name}_option"
            send(method_name, validation_class)
          end

          ########################################################################

          def register_required_option(validation_class)
            create_option(
              name: :required,
              validation_class:,
              define_methods: required_define_methods,
              define_conflicts: required_define_conflicts,
              need_for_checks: true,
              body_key: :is,
              body_fallback: true,
              detect_advanced_mode: true,
              return_value_on_access: false
            )
          end

          def register_types_option(validation_class) # rubocop:disable Metrics/MethodLength
            create_option(
              name: :types,
              validation_class:,
              original_value: extract_types_value,
              need_for_checks: true,
              body_key: :is,
              body_fallback: nil,
              detect_advanced_mode: true,
              return_value_on_access: true,
              normalizer: ->(v) { Array(v).uniq }
            )
          end

          def register_default_option(validation_class) # rubocop:disable Metrics/MethodLength
            create_option(
              name: :default,
              validation_class:,
              define_methods: [
                create_define_method(
                  name: :default_value_present?,
                  content: ->(option:) { !option[:is].nil? }
                )
              ],
              need_for_checks: true,
              body_key: :is,
              body_fallback: nil,
              detect_advanced_mode: false,
              return_value_on_access: true
            )
          end

          def register_must_option(validation_class) # rubocop:disable Metrics/MethodLength
            create_option(
              name: :must,
              validation_class:,
              define_methods: [
                create_define_method(
                  name: :must_present?,
                  content: ->(option:) { option[:rules].present? }
                )
              ],
              need_for_checks: true,
              body_key: :rules,
              body_fallback: nil,
              detect_advanced_mode: false,
              return_value_on_access: true
            )
          end

          def register_prepare_option(_validation_class) # rubocop:disable Metrics/MethodLength
            create_option(
              name: :prepare,
              validation_class: nil,
              define_methods: [
                create_define_method(
                  name: :prepare_present?,
                  content: ->(option:) { option[:in].present? }
                )
              ],
              need_for_checks: false,
              body_key: :in,
              body_fallback: false,
              detect_advanced_mode: true,
              return_value_on_access: false
            )
          end

          def extract_types_value
            type_option = @options.fetch(:type, nil)
            return nil if type_option.nil?

            # Advanced Mode: type: { is: String, message: "..." }
            return nil if type_option.is_a?(Hash) && type_option.key?(:is)

            # Simple Mode: type: String or type: [String, Integer]
            Array(type_option).uniq
          end

          ########################################################################

          def required_define_methods
            [
              create_define_method(
                name: :required?,
                content: ->(option:) { Servactory::Utils.true?(option[:is]) }
              ),
              create_define_method(
                name: :optional?,
                content: ->(option:) { !Servactory::Utils.true?(option[:is]) }
              )
            ]
          end

          def required_define_conflicts
            [
              Servactory::Maintenance::Attributes::DefineConflict.new(
                content: -> { :required_vs_default if @attribute.required? && @attribute.default_value_present? }
              )
            ]
          end

          ########################################################################

          def create_option(name:, validation_class:, **options)
            collection << Servactory::Maintenance::Attributes::Option.new(
              name:,
              attribute: @attribute,
              validation_class:,
              **options,
              **@options
            )
          end

          def create_define_method(name:, content:)
            Servactory::Maintenance::Attributes::DefineMethod.new(
              name:,
              content:
            )
          end
        end
      end
    end
  end
end
