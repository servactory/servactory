# frozen_string_literal: true

module Servactory
  module Stroma
    class Applier
      def initialize(target_class, hooks)
        @target_class = target_class
        @hooks = hooks
      end

      def apply!
        return if @hooks.empty?

        Registry.entries.each do |entry|
          @hooks.before(entry.key).each do |hook|
            @target_class.include(hook.extension)
          end

          @hooks.after(entry.key).each do |hook|
            @target_class.include(hook.extension)
          end
        end
      end
    end
  end
end
