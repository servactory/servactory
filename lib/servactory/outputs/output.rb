# frozen_string_literal: true

module Servactory
  module Outputs
    class Output
      attr_reader :name

      def initialize(
        name,
        collection_mode_class_names:,
        hash_mode_class_names:,
        **options
      )
        @name = name
        @collection_mode_class_names = collection_mode_class_names
        @hash_mode_class_names = hash_mode_class_names

        register_options(options: options)
      end

      def method_missing(name, *args, &block)
        option = @collection_of_options.find_by(name: name)

        return super if option.nil?

        option.body
      end

      def respond_to_missing?(name, *)
        @collection_of_options.names.include?(name) || super
      end

      def register_options(options:) # rubocop:disable Metrics/MethodLength
        options_registrar = Servactory::Maintenance::Attributes::Options::Registrar.register(
          attribute: self,
          collection_mode_class_names: @collection_mode_class_names,
          hash_mode_class_names: @hash_mode_class_names,
          options: options,
          features: {
            types: true,
            collection: true,
            hash: true
          }
        )

        @collection_of_options = options_registrar.collection
      end

      def options_for_checks
        @collection_of_options.options_for_checks
      end
    end
  end
end
