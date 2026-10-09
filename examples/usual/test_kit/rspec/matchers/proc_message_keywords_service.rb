# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class ProcMessageKeywordsService < ApplicationService::Base
          class Handler; end # rubocop:disable Lint/EmptyClass

          input :count,
                type: {
                  is: Integer,
                  message: lambda do |service:, input:, value:, expected_type:, given_type:|
                    "[#{service.class_name.demodulize}] `#{input.name}`: " \
                      "#{[value, expected_type, given_type].inspect}"
                  end
                }

          input :status,
                type: Symbol,
                inclusion: {
                  in: %i[active inactive],
                  message: lambda do |service:, input:, value:, code:, reason:, option_name:, option_value:|
                    "[#{service.class_name.demodulize}] `#{input.name}`: " \
                      "#{[value, code, reason, option_name, option_value].inspect}"
                  end
                }

          input :ids,
                type: Array,
                consists_of: {
                  type: Integer,
                  message: lambda do |service:, input:, value:, code:, reason:, option_name:, option_value:|
                    "[#{service.class_name.demodulize}] `#{input.name}`: " \
                      "#{[value, code, reason, option_name, option_value].inspect}"
                  end
                }

          input :config,
                type: Hash,
                schema: {
                  is: { key: { type: String } },
                  message: lambda do |service:, input:, value:, code:, reason:, option_name:, option_value:,
                                      key_name:, expected_type:, given_type:|
                    "[#{service.class_name.demodulize}] `#{input.name}`: " \
                      "#{[value.class, code, reason, option_name, option_value.keys, key_name, expected_type,
                          given_type].inspect}"
                  end
                }

          input :handler,
                type: Class,
                target: {
                  in: [Handler],
                  message: lambda do |service:, input:, value:, code:, reason:, option_name:, option_value:|
                    "[#{service.class_name.demodulize}] `#{input.name}`: " \
                      "#{[value, code, reason, option_name, option_value].inspect}"
                  end
                }

          def call; end
        end
      end
    end
  end
end
