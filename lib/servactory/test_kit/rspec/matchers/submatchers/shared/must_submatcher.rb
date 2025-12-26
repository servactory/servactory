# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Submatchers
          module Shared
            class MustSubmatcher < Base::Submatcher
              def initialize(context, must_names)
                super(context)
                @must_names = must_names
              end

              def description
                "must: #{must_names.join(', ')}"
              end

              protected

              def passes?
                attribute_must = attribute_data.fetch(:must)
                attribute_must_keys = attribute_must.keys.dup

                # NOTE: Dynamic options that are also `must` but tested separately
                attribute_must_keys.delete(:consists_of)
                attribute_must_keys.delete(:schema)
                attribute_must_keys.delete(:inclusion)

                attribute_must_keys.difference(must_names).empty? &&
                  must_names.difference(attribute_must_keys).empty?
              end

              def build_failure_message
                "should #{must_names.join(', ')}"
              end

              private

              attr_reader :must_names
            end
          end
        end
      end
    end
  end
end
