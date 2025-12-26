# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Base
          SubmatcherContext = Struct.new(
            :described_class,
            :attribute_type,
            :attribute_name,
            :attribute_data,
            :option_types,
            :last_submatcher,
            :i18n_root_key,
            keyword_init: true
          ) do
            def attribute_type_plural
              @attribute_type_plural ||= attribute_type.to_s.pluralize.to_sym
            end
          end
        end
      end
    end
  end
end
