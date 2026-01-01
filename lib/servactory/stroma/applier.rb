# frozen_string_literal: true

module Servactory
  module Stroma
    # Applies registered hooks to a target class.
    #
    # ## Purpose
    #
    # Iterates through all registered DSL modules and includes corresponding
    # before/after hooks in the target class. Maintains proper ordering:
    # for each entry, before hooks are included first, then after hooks.
    #
    # ## Usage
    #
    # ```ruby
    # applier = Servactory::Stroma::Applier.new(ChildService, hooks)
    # applier.apply!
    # # ChildService now includes all hook modules
    # ```
    #
    # ## Integration
    #
    # Called by Servactory::Stroma::DSL.inherited after duplicating parent's configuration.
    # Uses Servactory::Stroma::Registry.entries to determine hook application order.
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
