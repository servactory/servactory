# frozen_string_literal: true

module ApplicationService
  module Extensions
    module Transactional
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
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

          def call!(**)
            _wrap_in_transaction { super }
          end

          def _wrap_in_transaction(&block)
            return yield unless self.class.send(:transactional_enabled)

            transaction_class = self.class.send(:transactional_class) || default_transaction_class

            transaction_class.transaction(&block)
          end

          def default_transaction_class
            fail!(message: "Transaction class not configured")
          end
        end
      end
    end
  end
end
