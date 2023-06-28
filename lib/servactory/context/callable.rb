# frozen_string_literal: true

module Servactory
  module Context
    module Callable
      def call!(arguments = {}) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        context_store = Store.new(self)

        assign_data_with(context_store.context, arguments)

        inputs_workbench.find_unnecessary!
        inputs_workbench.check_rules!
        outputs_workbench.find_conflicts_in!(
          collection_of_internals: collection_of_internals
        )

        inputs_workbench.validate!

        methods_workbench.run!

        Servactory::Result.success_for(
          context: context_store.context,
          collection_of_outputs: collection_of_outputs
        )
      end

      def call(arguments = {}) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        context_store = Store.new(self)

        assign_data_with(context_store.context, arguments)

        inputs_workbench.find_unnecessary!
        inputs_workbench.check_rules!
        outputs_workbench.find_conflicts_in!(
          collection_of_internals: collection_of_internals
        )

        inputs_workbench.validate!

        methods_workbench.run!

        Servactory::Result.success_for(
          context: context_store.context,
          collection_of_outputs: collection_of_outputs
        )
      rescue Servactory.configuration.failure_class => e
        Servactory::Result.failure_for(exception: e)
      end

      private

      def assign_data_with(context, arguments)
        inputs_workbench.assign(
          context: context,
          arguments: arguments
        )

        internals_workbench.assign(context: context)
        outputs_workbench.assign(context: context)
        methods_workbench.assign(context: context)
      end
    end
  end
end
