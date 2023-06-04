# frozen_string_literal: true

module Servactory
  module Methods
    module DSL
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited(child)
          super

          child.send(:collection_of_methods).merge(collection_of_methods)
        end

        private

        def stage(&block)
          @stage = Stage.new(position: next_position)

          instance_eval(&block)

          # @stage_wrapper = nil
          # @stage_rollback = nil

          @stage = nil

          nil
        end

        def wrap_in(wrapper)
          # @stage_wrapper = wrapper

          @stage.wrapper = wrapper
        end

        def rollback(rollback)
          # @stage_rollback = rollback

          @stage.rollback = rollback
        end

        def make(name, position: nil, **options)
          position = position.presence || next_position

          @stage = @stage.presence || Stage.new(position: position)

          @stage.methods << Method.new(
            name,
            position: position,
            **options
          )

          collection_of_stages << @stage

          # collection_of_methods << Method.new(
          #   name,
          #   position: position,
          #   wrapper: wrapper,
          #   rollback: @stage_rollback.presence,
          #   **options
          # )
        end

        def method_missing(shortcut_name, *args, &block)
          return super unless Servactory.configuration.method_shortcuts.include?(shortcut_name)

          method_options = args.last.is_a?(Hash) ? args.pop : {}

          args.each do |method_name|
            make(:"#{shortcut_name}_#{method_name}", **method_options)
          end
        end

        def respond_to_missing?(shortcut_name, *)
          Servactory.configuration.method_shortcuts.include?(shortcut_name) || super
        end

        def next_position
          collection_of_stages.size + 1
        end

        def collection_of_stages
          @collection_of_stages ||= StageCollection.new
        end

        def collection_of_methods
          @collection_of_methods ||= MethodCollection.new
        end

        def methods_workbench
          @methods_workbench ||= Workbench.work_with(collection_of_stages)
        end
      end
    end
  end
end
