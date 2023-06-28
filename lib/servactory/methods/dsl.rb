# frozen_string_literal: true

module Servactory
  module Methods
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
        base.include(ClassMethods2)
      end

      module ClassMethods2
        def call!(arguments, collection_of_inputs)
          Servactory::Inputs::Tools::Validation.validate!(self, arguments, collection_of_inputs)

          # self.class.send(:methods_workbench).run!
          run_methods!
        end

        def run_methods!
          return try_to_use_call if self.class.send(:collection_of_stages).empty?

          self.class.send(:collection_of_stages).sorted_by_position.each do |stage|
            call_stage(stage)
          end
        end

        private

        def try_to_use_call
          try(:send, :call)
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
          wrapper.call(methods: -> { call_methods(methods) })
        rescue StandardError => e
          send(rollback, e) if rollback.present?
        end

        def call_methods(methods)
          methods.each do |make_method|
            next if unnecessary_for_make?(make_method)

            send(make_method.name)
          end
        end

        def unnecessary_for_stage?(stage)
          condition = stage.condition
          # is_condition_opposite = stage.is_condition_opposite

          result = prepare_condition_for(condition) # rubocop:disable Style/RedundantAssignment

          # is_condition_opposite ? !result : result
          result
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

          !condition.call(context: self)
        end
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_stages).merge(collection_of_stages)
        end

        private

        def stage(&block)
          @current_stage = Stage.new(position: next_position)

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

          @current_stage.condition = condition
        end

        def make(name, position: nil, **options)
          position = position.presence || next_position

          current_stage = @current_stage.presence || Stage.new(position: position)

          current_stage.methods << Method.new(
            name,
            position: position,
            **options
          )

          collection_of_stages << current_stage
        end

        def method_missing(name, *args, &block)
          if Servactory.configuration.aliases_for_make.include?(name)
            return method_missing_for_aliases_for_make(name, *args, &block)
          end

          if Servactory.configuration.shortcuts_for_make.include?(name)
            return method_missing_for_shortcuts_for_make(name, *args, &block)
          end

          super
        end

        def method_missing_for_aliases_for_make(_alias_name, *args, &block) # rubocop:disable Lint/UnusedMethodArgument
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
          Servactory.configuration.aliases_for_make.include?(name) ||
            Servactory.configuration.shortcuts_for_make.include?(name) ||
            super
        end

        def next_position
          collection_of_stages.size + 1
        end

        def collection_of_stages
          @collection_of_stages ||= StageCollection.new
        end

        def methods_workbench
          @methods_workbench ||= Workbench.work_with(collection_of_stages)
        end
      end
    end
  end
end
