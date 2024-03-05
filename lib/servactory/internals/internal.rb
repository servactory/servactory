# frozen_string_literal: true

module Servactory
  module Internals
    class Internal
      class Work
        attr_reader :name,
                    :types

        def initialize(input)
          @name = input.name
          @types = input.types
        end
      end

      attr_reader :name,
                  :collection_of_options

      def initialize(
        name,
        *helpers,
        collection_mode_class_names:,
        hash_mode_class_names:,
        option_helpers:,
        **options
      )
        @name = name
        @collection_mode_class_names = collection_mode_class_names
        @hash_mode_class_names = hash_mode_class_names
        @option_helpers = option_helpers

        register_options(helpers: helpers, options: options)
      end

      def method_missing(name, *args, &block)
        option = @collection_of_options.find_by(name: name)

        return super if option.nil?

        option.body
      end

      def respond_to_missing?(name, *)
        @collection_of_options.names.include?(name) || super
      end

      def register_options(helpers:, options:) # rubocop:disable Metrics/MethodLength
        options = apply_helpers_for_options(helpers: helpers, options: options) if helpers.present?

        options_registrar = Servactory::Maintenance::Attributes::Options::Registrar.register(
          attribute: self,
          collection_mode_class_names: @collection_mode_class_names,
          hash_mode_class_names: @hash_mode_class_names,
          options: options,
          features: {
            types: true,
            collection: true,
            hash: true,
            inclusion: true,
            must: true
          }
        )

        @collection_of_options = options_registrar.collection
      end

      def apply_helpers_for_options(helpers:, options:)
        prepared_options = {}

        helpers.each do |helper|
          found_helper = @option_helpers.find_by(name: helper)

          next if found_helper.blank?

          prepared_options.merge!(found_helper.equivalent)
        end

        options.merge(prepared_options)
      end

      def options_for_checks
        @collection_of_options.options_for_checks
      end

      def system_name
        self.class.name.demodulize.downcase.to_sym
      end

      def i18n_name
        system_name.to_s.pluralize
      end

      def input?
        false
      end

      def internal?
        true
      end

      def output?
        false
      end
    end
  end
end
