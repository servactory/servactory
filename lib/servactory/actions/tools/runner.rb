# frozen_string_literal: true

module Servactory
  module Actions
    module Tools
      # Executes service actions within stages.
      #
      # ## Purpose
      #
      # Orchestrates the execution of service actions, handling stage wrappers,
      # rollbacks, and conditional execution (only_if/only_unless). Provides
      # the core execution engine for Servactory services.
      #
      # ## Usage
      #
      # ```ruby
      # Runner.run!(context, collection_of_stages)
      # ```
      #
      # ## Integration
      #
      # Called by Servactory::Context::Callable to execute all actions
      # defined in a service. Works with Stages::Collection and Actions::Collection.
      class Runner
        # Runs the service actions.
        #
        # @param context [Object] The service context
        # @param collection_of_stages [Stages::Collection] The stages to execute
        # @return [void]
        def self.run!(...)
          new(...).run!
        end

        # Creates a new runner instance.
        #
        # @param context [Object] The service context with inputs/outputs
        # @param collection_of_stages [Stages::Collection] Collection of stages to execute
        def initialize(context, collection_of_stages)
          @context = context
          @collection_of_stages = collection_of_stages
        end

        # Executes all stages in position order.
        #
        # Falls back to calling the service's `call` method if no stages defined.
        #
        # @return [void]
        def run!
          return use_call if @collection_of_stages.empty?

          @collection_of_stages.sorted_by_position.each do |stage|
            call_stage(stage)
          end
        end

        private

        # Falls back to the service's call method when no stages defined.
        #
        # @return [void]
        def use_call
          @context.send(:call)
        end

        # Executes a single stage with its actions.
        #
        # Handles wrapper execution, rollbacks, and conditional skipping.
        #
        # @param stage [Stages::Stage] The stage to execute
        # @return [void]
        def call_stage(stage)
          return if should_skip?(stage)

          actions = stage.actions.sorted_by_position

          if stage.wrapper.is_a?(Proc)
            call_wrapper_with_actions(stage.wrapper, stage.rollback, actions)
          elsif stage.rollback.present?
            call_actions_with_rollback(stage.rollback, actions)
          else
            call_actions(actions)
          end
        end

        # Executes actions within a wrapper proc.
        #
        # Handles exceptions by calling rollback if defined,
        # otherwise fails the service with the exception details.
        #
        # @param wrapper [Proc] The wrapper proc (e.g., transaction block)
        # @param rollback [Symbol, nil] Optional rollback method name
        # @param actions [Collection] Actions to execute within wrapper
        # @return [void]
        def call_wrapper_with_actions(wrapper, rollback, actions) # rubocop:disable Metrics/MethodLength
          wrapper.call(methods: -> { call_actions(actions) }, context: @context)
        rescue StandardError => e
          if rollback.present?
            @context.send(rollback, e)
          else
            @context.fail!(
              message: e.message,
              meta: {
                original_exception: e
              }
            )
          end
        end

        # Executes actions with rollback support but no wrapper.
        #
        # If an exception occurs, calls the rollback method with the exception.
        #
        # @param rollback [Symbol] The rollback method name
        # @param actions [Collection] Actions to execute
        # @return [void]
        def call_actions_with_rollback(rollback, actions)
          call_actions(actions)
        rescue StandardError => e
          @context.send(rollback, e)
        end

        # Executes a collection of actions in order.
        #
        # @param actions [Collection] Actions to execute
        # @return [void]
        def call_actions(actions)
          actions.each do |action|
            next if should_skip?(action)

            call_action(action)
          end
        end

        # Executes a single action by name.
        #
        # @param action [Action] The action to execute
        # @return [void]
        # @raise [StandardError] Re-raises unless handled by rescue handler
        def call_action(action)
          @context.send(action.name)
        rescue StandardError => e
          rescue_with_handler(e) || raise
        end

        # Determines if an entity (stage or action) should be skipped.
        #
        # Uses the entity's condition and is_condition_opposite flag:
        # - only_if: skips if condition is NOT met
        # - only_unless: skips if condition IS met
        #
        # @param entity [Stages::Stage, Action] The entity to check
        # @return [Boolean] true if entity should be skipped
        def should_skip?(entity)
          condition_result = condition_met?(entity.condition)

          # only_if (is_condition_opposite = false): skip if condition is NOT met
          # only_unless (is_condition_opposite = true): skip if condition IS met
          entity.is_condition_opposite ? condition_result : !condition_result
        end

        # Evaluates a condition value.
        #
        # Handles nil (always true), boolean, and Proc conditions.
        #
        # @param condition [Proc, Boolean, nil] The condition to evaluate
        # @return [Boolean] true if condition is met
        def condition_met?(condition)
          return true if condition.nil?

          if condition.is_a?(Proc)
            condition.call(context: @context)
          else
            Servactory::Utils.true?(condition)
          end
        end

        # Attempts to handle an exception with configured rescue handlers.
        #
        # @param exception [Exception] The exception to handle
        # @return [Exception, nil] The exception if handled, nil otherwise
        def rescue_with_handler(exception) # rubocop:disable Metrics/MethodLength
          _, handler = @context.config.action_rescue_handlers.reverse_each.detect do |class_or_name, _|
            if (detected_exception = Servactory::Utils.constantize_class(class_or_name))
              detected_exception === exception # rubocop:disable Style/CaseEquality
            end
          end

          return if handler.nil?

          @context.fail!(
            message: handler.call(exception:),
            meta: {
              original_exception: exception
            }
          )
        end
      end
    end
  end
end
