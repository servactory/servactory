# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      module Options
        class Registrar # rubocop:disable Metrics/ClassLength
          DEFAULT_FEATURES = {
            required: false,
            types: false,
            default: false,
            collection: false,
            hash: false,
            inclusion: false,
            must: false,
            prepare: false
          }.freeze

          private_constant :DEFAULT_FEATURES

          def self.register(...)
            new(...).register
          end

          def initialize(attribute:, collection_mode_class_names:, hash_mode_class_names:, options:, features:)
            @attribute = attribute
            @collection_mode_class_names = collection_mode_class_names
            @hash_mode_class_names = hash_mode_class_names
            @options = options
            @features = DEFAULT_FEATURES.merge(features)
          end

          ########################################################################

          def register # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
            # Check Class: Servactory::Inputs::Validations::Required
            register_required_option if @features.fetch(:required)

            # Check Class: Servactory::Inputs::Validations::Type
            register_types_option if @features.fetch(:types)
            register_default_option if @features.fetch(:default)
            register_collection_option if @features.fetch(:collection)
            register_hash_option if @features.fetch(:hash)

            # Check Class: Servactory::Inputs::Validations::Inclusion
            register_inclusion_option if @features.fetch(:inclusion)

            # Check Class: Servactory::Inputs::Validations::Must
            register_must_option if @features.fetch(:must)

            # Check Class: nil
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
              validation_class: Servactory::Inputs::Validations::Type,
              original_value: Array(@options.fetch(:type)),
              need_for_checks: true,
              body_fallback: nil,
              with_advanced_mode: false
            )
          end

          def register_default_option # rubocop:disable Metrics/MethodLength
            collection << Servactory::Maintenance::Attributes::Option.new(
              name: :default,
              attribute: @attribute,
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
              **@options
            )
          end

          def register_collection_option # rubocop:disable Metrics/MethodLength
            collection << Servactory::Maintenance::Attributes::Option.new(
              name: :consists_of,
              attribute: @attribute,
              validation_class: Servactory::Inputs::Validations::Type,
              define_methods: [
                Servactory::Maintenance::Attributes::DefineMethod.new(
                  name: :collection_mode?,
                  content: ->(**) { @collection_mode_class_names.include?(@options.fetch(:type)) }
                )
              ],
              define_conflicts: [
                Servactory::Maintenance::Attributes::DefineConflict.new(
                  content: lambda {
                             :collection_vs_inclusion if @attribute.collection_mode? && @attribute.inclusion_present?
                           }
                )
              ],
              need_for_checks: false,
              body_key: :type,
              body_value: String,
              body_fallback: String,
              **@options
            )
          end

          def register_hash_option # rubocop:disable Metrics/MethodLength
            collection << Servactory::Maintenance::Attributes::Option.new(
              name: :schema,
              attribute: @attribute,
              validation_class: Servactory::Inputs::Validations::Type,
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
              **@options
            )
          end

          def register_must_option # rubocop:disable Metrics/MethodLength
            collection << Servactory::Maintenance::Attributes::Option.new(
              name: :must,
              attribute: @attribute,
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
              **@options
            )
          end

          def register_prepare_option # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
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
                  content: -> { :prepare_vs_collection if @attribute.prepare_present? && @attribute.collection_mode? }
                ),
                Servactory::Maintenance::Attributes::DefineConflict.new(
                  content: -> { :prepare_vs_inclusion if @attribute.prepare_present? && @attribute.inclusion_present? }
                ),
                Servactory::Maintenance::Attributes::DefineConflict.new(
                  content: -> { :prepare_vs_must if @attribute.prepare_present? && @attribute.must_present? }
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