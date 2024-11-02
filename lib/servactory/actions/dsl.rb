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

        # NOTE: Based on https://github.com/rails/rails/blob/main/activesupport/lib/active_support/rescuable.rb
        def fail_on!(*class_names, with: nil, &block) # rubocop:disable Metrics/MethodLength
          with ||= block || ->(exception:) { exception.message }

          class_names.each do |class_name|
            key = if class_name.is_a?(Module) && class_name.respond_to?(:===)
                    class_name.name
                  elsif class_name.is_a?(String)
                    class_name
                  else
                    raise ArgumentError,
                          "#{class_name.inspect} must be an Exception class or a String referencing an Exception class"
                  end

            # Put the new handler at the end because the list is read in reverse.
            config.action_rescue_handlers += [[key, with]]
          end
        end

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

          current_stage = @current_stage.presence || Stages::Stage.new(position:)

          current_stage.methods << Action.new(
            name,
            position:,
            **options
          )

          collection_of_stages << current_stage
        end

        def method_missing(name, ...)
          return method_missing_for_action_aliases(name, ...) if config.action_aliases.include?(name)

          return method_missing_for_shortcuts_for_make(name, ...) if config.action_shortcuts.include?(name)

          super
        end

        def method_missing_for_action_aliases(_alias_name, *args)
          method_name = args.first
          method_options = args.last.is_a?(Hash) ? args.pop : {}

          return if method_name.nil?

          make(method_name, **method_options)
        end

        def method_missing_for_shortcuts_for_make(shortcut_name, *args)
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
