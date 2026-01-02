# frozen_string_literal: true

module ApplicationService
  module Extensions
    module ApiAction
      module DSL
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          private

          def api_action(name, **options)
            make :"perform_#{name}_request", **options
            make :"handle_#{name}_response!"
          end
        end
      end
    end
  end
end
