# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Concerns
          module AttributeDataAccess
            def self.included(base)
              base.include(InstanceMethods)
            end

            module InstanceMethods
              def described_class = context&.described_class
              def attribute_type = context&.attribute_type
              def attribute_name = context&.attribute_name
              def attribute_type_plural = context&.attribute_type_plural
              def i18n_root_key = context&.i18n_root_key

              def attribute_data
                context.attribute_data
              end

              def fetch_option(key, default = nil)
                attribute_data.fetch(key, default)
              end

              def option_present?(key)
                return false unless attribute_data.key?(key)

                value = attribute_data[key]
                !value.nil? && (!value.respond_to?(:empty?) || !value.empty?)
              end
            end
          end
        end
      end
    end
  end
end
