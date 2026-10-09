# frozen_string_literal: true

module Usual
  module TestKit
    module Rspec
      module Matchers
        class ValidWithProcMessageService < ApplicationService::Base
          class Handler; end # rubocop:disable Lint/EmptyClass

          input :status,
                type: Symbol,
                inclusion: {
                  in: %i[active inactive],
                  message: lambda do |service:, input:, value:, code:, reason:, option_name:, option_value:|
                    "[#{service.class_name.demodulize}] `#{input.name}`: " \
                      "#{[value, code, reason, option_name, option_value].inspect}"
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

          input :state,
                type: Symbol,
                must: {
                  be_known: {
                    is: ->(value:, **) { %i[active inactive].include?(value) },
                    message: "Input `state` is unknown"
                  }
                },
                inclusion: {
                  in: %i[active inactive],
                  message: ->(input:, value:, **) { "Input `#{input.name}` does not include #{value.inspect}" }
                }

          input :worker,
                type: Class,
                must: {
                  be_known: {
                    is: ->(value:, **) { value == Handler },
                    message: "Input `worker` is unknown"
                  }
                },
                target: {
                  in: [Handler],
                  message: ->(input:, value:, **) { "Input `#{input.name}` does not target #{value.inspect}" }
                }

          def call; end
        end
      end
    end
  end
end
