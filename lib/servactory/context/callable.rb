# frozen_string_literal: true

module Servactory
  module Context
    module Callable
      def call!(attributes = {}) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        @context_store = Store.new(self)

        assign_data_with(attributes)

        input_attributes_workbench.find_unnecessary!
        input_attributes_workbench.check_rules!
        output_attributes_workbench.find_conflicts_in!(
          collection_of_internal_attributes: collection_of_internal_attributes
        )

        prepare_data

        input_attributes_workbench.check!

        make_methods_workbench.run!

        context_store.context.raise_first_fail

        Servactory::Result.prepare_for(
          context: context_store.context,
          collection_of_output_attributes: collection_of_output_attributes
        )
      end

      def call(attributes = {}) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        @context_store = Store.new(self)

        assign_data_with(attributes)

        input_attributes_workbench.find_unnecessary!
        input_attributes_workbench.check_rules!
        output_attributes_workbench.find_conflicts_in!(
          collection_of_internal_attributes: collection_of_internal_attributes
        )

        prepare_data

        input_attributes_workbench.check!

        make_methods_workbench.run!

        Servactory::Result.prepare_for(
          context: context_store.context,
          collection_of_output_attributes: collection_of_output_attributes
        )
      end

      private

      attr_reader :context_store

      def assign_data_with(attributes)
        input_attributes_workbench.assign(
          context: context_store.context,
          attributes: attributes
        )

        internal_attributes_workbench.assign(context: context_store.context)
        output_attributes_workbench.assign(context: context_store.context)
        make_methods_workbench.assign(context: context_store.context)
      end

      def prepare_data
        input_attributes_workbench.prepare     # 1

        output_attributes_workbench.prepare    # 2
        internal_attributes_workbench.prepare  # 3
      end
    end
  end
end
