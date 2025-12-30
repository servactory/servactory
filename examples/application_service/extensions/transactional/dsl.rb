# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Transactional
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        def self.register_hooks(service_class)
          service_class.around_actions(:_wrap_in_transaction, priority: 0)
        end

        module ClassMethods
          private

          attr_accessor :transactional_enabled,
                        :transactional_class

          def transactional!(transaction_class: nil)
            self.transactional_enabled = true
            self.transactional_class = transaction_class
          end
        end

        module InstanceMethods
          private

          def _wrap_in_transaction(proceed:, **)
            return proceed.call unless self.class.send(:transactional_enabled)

            transaction_class = self.class.send(:transactional_class) || default_transaction_class

            transaction_class.transaction { proceed.call }
          end

          def default_transaction_class
            fail!(message: "Transaction class not configured")
          end
        end
      end
    end
  end
end
