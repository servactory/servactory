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
          instance_eval(&block)

          @wrapper = nil

          nil
        end

        def wrap_in(wrapper)
          @wrapper = wrapper
        end

        def make(name, position: nil, **options)
          position = position.presence || next_position

          collection_of_methods << Method.new(
            name,
            position: position,
            wrapper: @wrapper.presence || :"#{name}_#{position}",
            **options
          )
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
          collection_of_methods.size + 1
        end

        def collection_of_methods
          @collection_of_methods ||= Collection.new
        end

        def methods_workbench
          @methods_workbench ||= Workbench.work_with(collection_of_methods)
        end
      end
    end
  end
end
