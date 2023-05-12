# frozen_string_literal: true

module Servactory
  module Context
    module Callable
      def call!(arguments = {}) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        @context_store = Store.new(self)

        assign_data_with(arguments)

        input_arguments_workbench.find_unnecessary!
        input_arguments_workbench.check_rules!
        output_arguments_workbench.find_conflicts_in!(
          collection_of_internal_arguments: collection_of_internal_arguments
        )

        prepare_data

        input_arguments_workbench.check!

        stage_handyman.run_methods!

        context_store.context.raise_first_fail

        Servactory::Result.prepare_for(
          context: context_store.context,
          collection_of_output_arguments: collection_of_output_arguments
        )
      end

      private

      attr_reader :context_store

      def assign_data_with(arguments) # rubocop:disable Metrics/AbcSize
        input_arguments_workbench.assign(
          context: context_store.context,
          arguments: arguments,
          collection_of_input_options: collection_of_input_options
        )

        internal_arguments_workbench.assign(context: context_store.context)
        output_arguments_workbench.assign(context: context_store.context)
        stage_handyman&.assign(context: context_store.context)
      end

      def prepare_data
        input_arguments_workbench.prepare     # 1

        output_arguments_workbench.prepare    # 2
        internal_arguments_workbench.prepare  # 3
      end
    end
  end
end
