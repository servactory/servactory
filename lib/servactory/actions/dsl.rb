# frozen_string_literal: true

module Servactory
  module Actions
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
        base.include(Workspace)

        base.class_attribute :action_rescue_handlers_class_attr, default: []
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_stages).merge(collection_of_stages)
        end

        private

        # NOTE: Based on https://github.com/rails/rails/blob/main/activesupport/lib/active_support/rescuable.rb
        def fail_on!(*args, with: ->(exception:) { exception.message })
          exceptions = args.grep(String) + args.grep(Class)

          exceptions.each do |exception_class_or_name|
            key = Servactory::Utils.constantize_class(exception_class_or_name)

            self.action_rescue_handlers_class_attr += [[key, with]]
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

        def method_missing(name, *args, &block)
          return method_missing_for_action_aliases(*args) if config.action_aliases.include?(name)

          if (action_shortcut = config.action_shortcuts.find_by(name:)).present?
            return method_missing_for_shortcuts_for_make(action_shortcut, *args)
          end

          super
        end

        def method_missing_for_action_aliases(*args)
          method_name = args.first
          method_options = args.last.is_a?(Hash) ? args.pop : {}

          return if method_name.nil?

          make(method_name, **method_options)
        end

        def method_missing_for_shortcuts_for_make(action_shortcut, *args)
          method_options = args.last.is_a?(Hash) ? args.pop : {}

          args.each do |method_name|
            full_method_name = build_method_name_for_shortcuts_for_make_with(
              method_name.to_s,
              action_shortcut
            )

            make(full_method_name, **method_options)
          end
        end

        def build_method_name_for_shortcuts_for_make_with(method_name, action_shortcut)
          prefix = action_shortcut.fetch(:prefix)
          suffix = action_shortcut.fetch(:suffix)

          method_body, special_char =
            Servactory::Utils.extract_special_character_from(method_name.to_s)

          parts = []
          parts << "#{prefix}_" if prefix.present?
          parts << method_body
          parts << "_#{suffix}" if suffix.present?
          parts << special_char if special_char

          parts.join.to_sym
        end

        def respond_to_missing?(name, *_args)
          config.action_aliases.include?(name) || config.action_shortcuts.shortcuts.include?(name) || super
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
