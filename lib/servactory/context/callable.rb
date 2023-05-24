# frozen_string_literal: true

module Servactory
  module Context
    module Callable
      def call!(attributes = {}) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        @context_store = Store.new(self)

        assign_data_with(attributes)

        inputs_workbench.find_unnecessary!
        inputs_workbench.check_rules!
        outputs_workbench.find_conflicts_in!(
          collection_of_internal_attributes: collection_of_internal_attributes
        )

        prepare_data

        inputs_workbench.check!

        make_methods_workbench.run!

        context_store.context.raise_first_fail

        Servactory::Result.prepare_for(
          context: context_store.context,
          collection_of_outputs: collection_of_outputs
        )
      end

      def call(attributes = {}) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        @context_store = Store.new(self)

        assign_data_with(attributes)

        inputs_workbench.find_unnecessary!
        inputs_workbench.check_rules!
        outputs_workbench.find_conflicts_in!(
          collection_of_internal_attributes: collection_of_internal_attributes
        )

        prepare_data

        inputs_workbench.check!

        make_methods_workbench.run!

        Servactory::Result.prepare_for(
          context: context_store.context,
          collection_of_outputs: collection_of_outputs
        )
      end

      private

      attr_reader :context_store

      def assign_data_with(attributes)
        inputs_workbench.assign(
          context: context_store.context,
          attributes: attributes
        )

        internal_attributes_workbench.assign(context: context_store.context)
        outputs_workbench.assign(context: context_store.context)
        make_methods_workbench.assign(context: context_store.context)
      end

      def prepare_data
        inputs_workbench.prepare               # 1
        outputs_workbench.prepare    # 2
        internal_attributes_workbench.prepare  # 3
      end
    end
  end
end
