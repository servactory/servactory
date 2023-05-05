# frozen_string_literal: true

module ServiceFactory
  module Context
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def call!(arguments) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          @context_store ||= Store.new(self)

          assign_data_with(arguments)

          input_arguments_workbench.find_unnecessary!
          input_arguments_workbench.check_rules!
          output_arguments_workbench.find_conflicts_in!(collection_of_internal_arguments:)

          prepare_data

          input_arguments_workbench.check!

          stage_handyman.run_methods!

          ServiceFactory::Result.prepare_for(
            context: context_store.context,
            collection_of_output_arguments:
          )
        end

        private

        attr_reader :context_store

        def assign_data_with(arguments)
          input_arguments_workbench.assign(context: context_store.context, arguments:)  # 1
          internal_arguments_workbench.assign(context: context_store.context)           # 2
          output_arguments_workbench.assign(context: context_store.context)             # 3
          stage_handyman&.assign(context: context_store.context)                        # 4
        end

        def prepare_data
          input_arguments_workbench.prepare     # 1

          output_arguments_workbench.prepare    # 2
          internal_arguments_workbench.prepare  # 3
        end

        def configuration(&)
          context_configuration = ServiceFactory::Context::Configuration.new

          context_configuration.instance_eval(&)
        end
      end
    end
  end
end
