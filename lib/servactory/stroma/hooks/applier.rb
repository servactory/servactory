# frozen_string_literal: true

module Servactory
  module Stroma
    module Hooks
      # Applies registered hooks to a target class.
      #
      # ## Purpose
      #
      # Iterates through all registered DSL modules and includes corresponding
      # before/after hooks in the target class. For each registry entry,
      # before hooks are included first, then after hooks.
      #
      # ## Usage
      #
      # ```ruby
      # applier = Servactory::Stroma::Hooks::Applier.new(ChildService, hooks)
      # applier.apply!
      # # ChildService now includes all hook modules
      # ```
      #
      # ## Integration
      #
      # Called by Servactory::Stroma::DSL.inherited after duplicating
      # parent's configuration. Uses Registry.entries to determine
      # hook application order.
      class Applier
        # Creates a new applier for applying hooks to a class.
        #
        # @param target_class [Class] The class to apply hooks to
        # @param hooks [Collection] The hooks collection to apply
        def initialize(target_class, hooks)
          @target_class = target_class
          @hooks = hooks
        end

        # Applies all registered hooks to the target class.
        #
        # For each registry entry, includes before hooks first,
        # then after hooks. Does nothing if hooks collection is empty.
        #
        # @return [void]
        #
        # @example
        #   applier.apply!
        #   # Target class now includes all extension modules
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
end
