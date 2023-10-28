# frozen_string_literal: true

module Servactory
  module Internals
    class Internal
      attr_reader :name,
                  :collection_mode_class_names,
                  :hash_mode_class_names

      def initialize(
        name,
        type:,
        collection_mode_class_names:,
        hash_mode_class_names:,
        **options
      )
        @name = name
        @collection_mode_class_names = collection_mode_class_names
        @hash_mode_class_names = hash_mode_class_names

        add_basic_options_with(type: type, options: options)
      end

      def method_missing(name, *args, &block)
        option = collection_of_options.find_by(name: name)

        return super if option.nil?

        option.body
      end

      def respond_to_missing?(name, *)
        collection_of_options.names.include?(name) || super
      end

      def add_basic_options_with(type:, options:)
        # Check Class: Servactory::Internals::Validations::Type
        add_types_option_with(type)
        add_collection_option_with(type, options)
        add_hash_option_with(type, options)
      end

      def add_types_option_with(type)
        collection_of_options << Servactory::Maintenance::Attributes::Option.new(
          name: :types,
          attribute: self,
          validation_class: Servactory::Internals::Validations::Type,
          original_value: Array(type),
          need_for_checks: true,
          body_fallback: nil,
          with_advanced_mode: false
        )
      end

      def add_collection_option_with(type, options) # rubocop:disable Metrics/MethodLength
        collection_of_options << Servactory::Maintenance::Attributes::Option.new(
          name: :consists_of,
          attribute: self,
          validation_class: Servactory::Internals::Validations::Type,
          define_methods: [
            Servactory::Maintenance::Attributes::DefineMethod.new(
              name: :collection_mode?,
              content: ->(**) { collection_mode_class_names.include?(type) }
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
          need_for_checks: false,
          body_fallback: {},
          with_advanced_mode: false,
          **options
        )
      end

      def collection_of_options
        @collection_of_options ||= Servactory::Maintenance::Attributes::OptionsCollection.new
      end

      def options_for_checks
        collection_of_options.options_for_checks
      end
    end
  end
end
