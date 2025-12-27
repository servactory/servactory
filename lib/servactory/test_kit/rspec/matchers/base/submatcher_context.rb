# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Base
          class SubmatcherContext
            attr_reader :described_class,
                        :attribute_type,
                        :attribute_name,
                        :attribute_data,
                        :option_types,
                        :last_submatcher,
                        :i18n_root_key

            def initialize(
              described_class:,
              attribute_type:,
              attribute_name:,
              attribute_data:,
              option_types: nil,
              last_submatcher: nil,
              i18n_root_key: nil
            )
              @described_class = described_class
              @attribute_type = attribute_type
              @attribute_name = attribute_name
              @attribute_data = attribute_data
              @option_types = option_types
              @last_submatcher = last_submatcher
              @i18n_root_key = i18n_root_key
            end

            def attribute_type_plural
              @attribute_type_plural ||= attribute_type.to_s.pluralize.to_sym
            end
          end
        end
      end
    end
  end
end
