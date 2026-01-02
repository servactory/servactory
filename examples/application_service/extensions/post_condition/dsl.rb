# frozen_string_literal: true

module ApplicationService
  module Extensions
    module PostCondition
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end

        module ClassMethods
          private

          def post_conditions
            @post_conditions ||= []
          end

          def post_condition!(name, message: nil, &block)
            post_conditions << {
              name: name,
              message: message,
              block: block
            }
          end
        end

        module InstanceMethods
          private

          def call!(**)
            super

            _verify_post_conditions
          end

          def _verify_post_conditions
            self.class.send(:post_conditions).each do |condition|
              result = instance_exec(outputs, &condition[:block])

              next if result

              message = condition[:message] || "Post-condition '#{condition[:name]}' failed"

              fail!(
                :post_condition_failed,
                message: message
              )
            end
          end
        end
      end
    end
  end
end
