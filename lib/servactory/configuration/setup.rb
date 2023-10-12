# frozen_string_literal: true

module Servactory
  module Configuration
    class Setup
      attr_accessor :input_error_class,
                    :internal_error_class,
                    :output_error_class,
                    :failure_class,
                    :collection_mode_class_names,
                    :object_mode_class_names,
                    :input_option_helpers,
                    :aliases_for_make,
                    :shortcuts_for_make

      def initialize
        @input_error_class = Servactory::Errors::InputError
        @internal_error_class = Servactory::Errors::InternalError
        @output_error_class = Servactory::Errors::OutputError

        @failure_class = Servactory::Errors::Failure

        @collection_mode_class_names =
          Servactory::Maintenance::CollectionMode::ClassNamesCollection.new(default_collection_mode_class_names)

        @object_mode_class_names =
          Servactory::Maintenance::ObjectMode::ClassNamesCollection.new(default_object_mode_class_names)

        @input_option_helpers =
          Servactory::Maintenance::Attributes::OptionHelpersCollection.new(default_input_option_helpers)

        @aliases_for_make = Servactory::Methods::AliasesForMake::Collection.new
        @shortcuts_for_make = Servactory::Methods::ShortcutsForMake::Collection.new
      end

      private

      def default_collection_mode_class_names
        Set[Array, Set]
      end

      def default_object_mode_class_names
        Set[Hash]
      end

      def default_input_option_helpers
        Set[
          Servactory::Maintenance::Attributes::OptionHelper.new(name: :optional, equivalent: { required: false }),
        ]
      end
    end
  end
end
