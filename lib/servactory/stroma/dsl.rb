# frozen_string_literal: true

module Servactory
  module Stroma
    module DSL
      def self.included(base)
        base.extend(ClassMethods)

        Registry.entries.each do |entry|
          base.include(entry.mod)
        end
      end

      module ClassMethods
        def self.extended(base)
          base.instance_variable_set(:@stroma, Configuration.new)
        end

        def inherited(child)
          super

          child.instance_variable_set(
            :@stroma,
            stroma.dup_for_inheritance
          )

          Applier.new(child, child.stroma.hooks).apply!
        end

        def stroma
          @stroma ||= Configuration.new
        end

        private

        def extensions(&block)
          @stroma_hooks_factory ||= HooksFactory.new(stroma.hooks)
          @stroma_hooks_factory.instance_eval(&block)
        end
      end
    end
  end
end
