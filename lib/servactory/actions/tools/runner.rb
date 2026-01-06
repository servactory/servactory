# frozen_string_literal: true

module Servactory
  module Actions
    module Tools
      class Runner
        def self.run!(...)
          new(...).run!
        end

        def initialize(context, collection_of_stages)
          @context = context
          @collection_of_stages = collection_of_stages
        end

        def run!
          return use_call if @collection_of_stages.empty?

          @collection_of_stages.sorted_by_position.each do |stage|
            call_stage(stage)
          end
        end

        private

        def use_call
          @context.send(:call)
        end

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

        def call_actions_with_rollback(rollback, actions)
          call_actions(actions)
        rescue StandardError => e
          @context.send(rollback, e)
        end

        def call_actions(actions)
          actions.each do |action|
            next if should_skip?(action)

            call_action(action)
          end
        end

        def call_action(action)
          @context.send(action.name)
        rescue StandardError => e
          rescue_with_handler(e) || raise
        end

        def should_skip?(entity)
          condition_result = condition_met?(entity.condition)

          # only_if (is_condition_opposite = false): skip if condition is NOT met
          # only_unless (is_condition_opposite = true): skip if condition IS met
          entity.is_condition_opposite ? condition_result : !condition_result
        end

        def condition_met?(condition)
          return true if condition.nil?

          if condition.is_a?(Proc)
            condition.call(context: @context)
          else
            Servactory::Utils.true?(condition)
          end
        end

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
