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
            transactional_enabled = self.class.send(:transactional_enabled)

            unless transactional_enabled
              super
              return
            end

            transaction_class = self.class.send(:transactional_class)

            fail!(message: "Transaction class not configured") if transaction_class.nil?

            transaction_class.transaction { super }
          end
        end
      end
    end
  end
end
