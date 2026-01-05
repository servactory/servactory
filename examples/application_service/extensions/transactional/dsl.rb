# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Transactional
      # Wraps service execution in a database transaction.
      #
      # ## Purpose
      #
      # Ensures service actions run within a database transaction.
      # Uses Stroma settings to store transaction configuration.
      #
      # ## Usage
      #
      # ```ruby
      # class MyService < ApplicationService::Base
      #   transactional! transaction_class: ActiveRecord::Base
      # end
      # ```
      #
      # ## Settings Access
      #
      # This extension uses the Stroma settings hierarchy:
      #
      # ```ruby
      # # ClassMethods:
      # stroma.settings[:actions][:transactional][:enabled] = true
      # stroma.settings[:actions][:transactional][:class] = ActiveRecord::Base
      #
      # # InstanceMethods:
      # self.class.stroma.settings[:actions][:transactional][:enabled]
      # ```
      #
      # ## Cross-Extension Coordination
      #
      # Extensions can read other extensions' settings:
      #
      # ```ruby
      # # rollback_settings = stroma.settings[:actions][:rollbackable]
      # # if rollback_settings[:method_name].present?
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
            stroma.settings[:actions][:transactional][:enabled] = true
            stroma.settings[:actions][:transactional][:class] = transaction_class
          end
        end

        module InstanceMethods
          private

          def call!(**)
            settings = self.class.stroma.settings[:actions][:transactional]
            enabled = settings[:enabled]

            unless enabled
              super
              return
            end

            transaction_class = settings[:class]

            fail!(message: "Transaction class not configured") if transaction_class.nil?

            transaction_class.transaction { super }
          end
        end
      end
    end
  end
end
