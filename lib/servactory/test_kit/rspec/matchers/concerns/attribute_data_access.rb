# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Concerns
          module AttributeDataAccess
            extend ActiveSupport::Concern

            included do
              delegate :described_class, :attribute_type, :attribute_name,
                       :attribute_type_plural, :i18n_root_key,
                       to: :context, allow_nil: true
            end

            def attribute_data
              context.attribute_data
            end

            def fetch_option(key, default = nil)
              attribute_data.fetch(key, default)
            end

            def option_present?(key)
              attribute_data.key?(key) && attribute_data[key].present?
            end
          end
        end
      end
    end
  end
end
