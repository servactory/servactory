# frozen_string_literal: true

module Servactory
  module Context
    module Callable
      def call!(arguments = {}) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        @context_store = Store.new(self)

        context_store.context.send(:assign_service_strict_mode, true)

        assign_data_with(arguments)

        inputs_workbench.find_unnecessary!
        inputs_workbench.check_rules!
        outputs_workbench.find_conflicts_in!(
          collection_of_internals: collection_of_internals
        )

        prepare_data

        inputs_workbench.validate!

        methods_workbench.run!

        context_store.context.raise_first_fail

        Servactory::Result.prepare_for(
          context: context_store.context,
          collection_of_outputs: collection_of_outputs
        )
      end

      def call(arguments = {}) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        @context_store = Store.new(self)

        context_store.context.send(:assign_service_strict_mode, false)

        assign_data_with(arguments)

        inputs_workbench.find_unnecessary!
        inputs_workbench.check_rules!
        outputs_workbench.find_conflicts_in!(
          collection_of_internals: collection_of_internals
        )

        prepare_data

        inputs_workbench.validate!

        methods_workbench.run!

        Servactory::Result.prepare_for(
          context: context_store.context,
          collection_of_outputs: collection_of_outputs
        )
      end

      private

      attr_reader :context_store

      def assign_data_with(arguments)
        inputs_workbench.assign(
          context: context_store.context,
          arguments: arguments
        )

        internals_workbench.assign(context: context_store.context)
        outputs_workbench.assign(context: context_store.context)
        methods_workbench.assign(context: context_store.context)
      end

      def prepare_data
        inputs_workbench.prepare
      end
    end
  end
end
