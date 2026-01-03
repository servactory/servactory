# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Transactional
      # Wraps service execution in a database transaction.
      #
      # ## Purpose
      #
      # Ensures service actions run within a database transaction.
      # Uses isolated extension configuration to store transaction settings.
      #
      # ## Usage
      #
      # ```ruby
      # class MyService < ApplicationService::Base
      #   transactional! transaction_class: ActiveRecord::Base
      # end
      # ```
      #
      # ## Configuration Isolation
      #
      # This extension uses isolated config namespace to prevent collisions:
      #
      # ```ruby
      # extension_config(:actions, :transactional)[:enabled] = true
      # extension_config(:actions, :transactional)[:class] = ActiveRecord::Base
      # ```
      #
      # ## Shared Access (if needed)
      #
      # Extensions can coordinate by reading other configs:
      #
      # ```ruby
      # # rollback_config = extension_config(:actions, :rollbackable)
      # # if rollback_config[:method_name].present?
      # #   # coordinate with rollbackable extension
      # # end
      # ```
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        module ClassMethods
          private

          def transactional!(transaction_class: nil)
            extension_config(:actions, :transactional)[:enabled] = true
            extension_config(:actions, :transactional)[:class] = transaction_class
          end
        end

        module InstanceMethods
          private

          def call!(**)
            config = self.class.extension_config(:actions, :transactional)
            enabled = config[:enabled]

            unless enabled
              super
              return
            end

            transaction_class = config[:class]

            fail!(message: "Transaction class not configured") if transaction_class.nil?

            transaction_class.transaction { super }
          end
        end
      end
    end
  end
end
