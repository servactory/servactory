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
          return if unnecessary_for_stage?(stage)

          wrapper = stage.wrapper
          rollback = stage.rollback
          actions = stage.actions.sorted_by_position

          if wrapper.is_a?(Proc)
            call_wrapper_with_actions(wrapper, rollback, actions)
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

        def call_actions(actions)
          actions.each do |action|
            next if unnecessary_for_make?(action)

            call_action(action)
          end
        end

        def call_action(action)
          @context.send(action.name)
        rescue StandardError => e
          rescue_with_handler(e) || raise
        end

        def unnecessary_for_stage?(stage)
          condition = stage.condition
          is_condition_opposite = stage.is_condition_opposite

          result = prepare_condition_for(condition)

          is_condition_opposite ? !result : result
        end

        def unnecessary_for_make?(make_action)
          condition = make_action.condition
          is_condition_opposite = make_action.is_condition_opposite

          result = prepare_condition_for(condition)

          is_condition_opposite ? !result : result
        end

        def prepare_condition_for(condition)
          return false if condition.nil?
          return !Servactory::Utils.true?(condition) unless condition.is_a?(Proc)

          !condition.call(context: @context)
        end

        def rescue_with_handler(exception) # rubocop:disable Metrics/MethodLength
          _, handler = @context.class.config.action_rescue_handlers.reverse_each.detect do |class_or_name, _|
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
