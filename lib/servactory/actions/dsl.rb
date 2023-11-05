# frozen_string_literal: true

module Servactory
  module Actions
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
        base.include(Workspace)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_stages).merge(collection_of_stages)
        end

        private

        def stage(&block)
          @current_stage = Stages::Stage.new(position: next_position)

          instance_eval(&block)

          @current_stage = nil

          nil
        end

        def wrap_in(wrapper)
          return if @current_stage.blank?

          @current_stage.wrapper = wrapper
        end

        def rollback(rollback)
          return if @current_stage.blank?

          @current_stage.rollback = rollback
        end

        def only_if(condition)
          return if @current_stage.blank?

          @current_stage.is_condition_opposite = false
          @current_stage.condition = condition
        end

        def only_unless(condition)
          return if @current_stage.blank?

          @current_stage.is_condition_opposite = true
          @current_stage.condition = condition
        end

        def make(name, position: nil, **options)
          position = position.presence || next_position

          current_stage = @current_stage.presence || Stages::Stage.new(position: position)

          current_stage.methods << Action.new(
            name,
            position: position,
            **options
          )

          collection_of_stages << current_stage
        end

        def method_missing(name, *args, &block)
          return method_missing_for_action_aliases(name, *args, &block) if config.action_aliases.include?(name)

          return method_missing_for_shortcuts_for_make(name, *args, &block) if config.action_shortcuts.include?(name)

          super
        end

        def method_missing_for_action_aliases(_alias_name, *args, &block) # rubocop:disable Lint/UnusedMethodArgument
          method_name = args.first
          method_options = args.last.is_a?(Hash) ? args.pop : {}

          return if method_name.nil?

          make(method_name, **method_options)
        end

        def method_missing_for_shortcuts_for_make(shortcut_name, *args, &block) # rubocop:disable Lint/UnusedMethodArgument
          method_options = args.last.is_a?(Hash) ? args.pop : {}

          args.each do |method_name|
            make(:"#{shortcut_name}_#{method_name}", **method_options)
          end
        end

        def respond_to_missing?(name, *)
          config.action_aliases.include?(name) || config.action_shortcuts.include?(name) || super
        end

        def next_position
          collection_of_stages.size + 1
        end

        def collection_of_stages
          @collection_of_stages ||= Stages::Collection.new
        end
      end
    end
  end
end
