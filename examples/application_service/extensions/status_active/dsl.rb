# frozen_string_literal: true

module ApplicationService
  module Extensions
    module StatusActive
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        module ClassMethods
          private

          attr_accessor :status_active_record

          def status_active!(record:)
            self.status_active_record = record
          end
        end

        module InstanceMethods
          def call!(**)
            super

            status_active_record = self.class.send(:status_active_record)
            return if status_active_record.nil?

            is_active = status_active_record.call(inputs: inputs).active?
            return if is_active

            fail!(message: "User is not active")
          end
        end
      end
    end
  end
end
