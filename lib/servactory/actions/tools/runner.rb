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
          methods = stage.methods.sorted_by_position

          if wrapper.is_a?(Proc)
            call_wrapper_with_methods(wrapper, rollback, methods)
          else
            call_methods(methods)
          end
        end

        def call_wrapper_with_methods(wrapper, rollback, methods)
          wrapper.call(methods: -> { call_methods(methods) }, context: @context)
        rescue StandardError => e
          @context.send(rollback, e) if rollback.present?
        end

        def call_methods(methods)
          methods.each do |method|
            next if unnecessary_for_make?(method)

            @context.send(method.name)
          end
        end

        def unnecessary_for_stage?(stage)
          condition = stage.condition
          is_condition_opposite = stage.is_condition_opposite

          result = prepare_condition_for(condition)

          is_condition_opposite ? !result : result
        end

        def unnecessary_for_make?(make_method)
          condition = make_method.condition
          is_condition_opposite = make_method.is_condition_opposite

          result = prepare_condition_for(condition)

          is_condition_opposite ? !result : result
        end

        def prepare_condition_for(condition)
          return false if condition.nil?
          return !Servactory::Utils.true?(condition) unless condition.is_a?(Proc)

          !condition.call(context: @context)
        end
      end
    end
  end
end
