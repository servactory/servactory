# frozen_string_literal: true

module Servactory
  module TestKit
    module Rspec
      module Matchers
        module Concerns
          # Concern for calling Proc messages the way the library calls them.
          #
          # ## Purpose
          #
          # ProcMessage calls a Proc message of an attribute option with the
          # complete set of keyword arguments the library passes to it while
          # the service runs, so every submatcher builds Proc messages the same
          # way. A Proc that would raise while the service runs, for example
          # because it does not accept every keyword, raises here too.
          #
          # ## Keyword Arguments
          #
          # Every Proc message receives `service:`, the attribute (`input:`,
          # `internal:` or `output:`) and `value:`, plus the keywords of its
          # option:
          #
          # - `:required` - no other keywords
          # - `:type` - `expected_type:`, `given_type:`
          # - `:must` - `code:`, `reason:`, `meta:`
          # - `:dynamic_option` (`consists_of`, `inclusion`, `target`) -
          #   `code:`, `reason:`, `option_name:`, `option_value:`
          # - `:schema` - `code:`, `reason:`, `option_name:`, `option_value:`,
          #   `key_name:`, `expected_type:`, `given_type:`
          #
          # The library passes the same keywords for every failure reason of an
          # option, for example `key_name:` is passed as `nil` when a `schema`
          # attribute is not Hash-compatible. `reason:` itself is `nil` unless
          # given, because the reason of a failure is known only while the
          # service runs.
          #
          # Keywords without a given value, such as `value:`, are `nil`.
          #
          # ## Usage
          #
          # ```ruby
          # class MySubmatcher < Base::Submatcher
          #   include Concerns::ProcMessage
          #
          #   def passes?
          #     call_proc_message(message, :type, expected_type: "Integer") == "Must be an Integer"
          #   end
          # end
          # ```
          module ProcMessage
            # Keywords the library passes to Proc messages by option, besides
            # `service:`, the attribute and `value:`.
            OPTION_KEYWORDS = {
              required: [].freeze,
              type: %i[expected_type given_type].freeze,
              must: %i[code reason meta].freeze,
              dynamic_option: %i[code reason option_name option_value].freeze,
              schema: %i[code reason option_name option_value key_name expected_type given_type].freeze
            }.freeze

            # Includes InstanceMethods in the including class.
            #
            # @param base [Class] The class including this concern
            # @return [void]
            def self.included(base)
              base.include(InstanceMethods)
            end

            # Instance methods added by this concern.
            module InstanceMethods
              # Calls a Proc message with the keyword arguments the library passes to it.
              #
              # @param message [Proc] The message of the option
              # @param option [Symbol] The option, a key of OPTION_KEYWORDS
              # @param values [Hash{Symbol => Object}] Known values of the keywords
              # @return [Object] The message built by the Proc
              # @raise [ArgumentError] If a value is given for a keyword the library does not pass
              def call_proc_message(message, option, **values)
                message.call(**proc_message_arguments(option, **values))
              end

              # Builds the keyword arguments the library passes to a Proc message.
              #
              # @param option [Symbol] The option, a key of OPTION_KEYWORDS
              # @param values [Hash{Symbol => Object}] Known values of the keywords
              # @return [Hash{Symbol => Object}] Keyword arguments, `nil` for keywords without a given value
              # @raise [ArgumentError] If a value is given for a keyword the library does not pass
              def proc_message_arguments(option, **values)
                arguments = {
                  service: proc_message_service_info,
                  attribute_type => attribute_data.fetch(:actor),
                  value: nil,
                  **OPTION_KEYWORDS.fetch(option).to_h { |keyword| [keyword, nil] }
                }

                unknown = values.keys - arguments.keys
                raise ArgumentError, "Unknown keywords for #{option} messages: #{unknown.join(', ')}" if unknown.any?

                arguments.merge(values)
              end

              private

              # Returns the service information passed to Proc messages.
              #
              # @return [Object] The service information
              def proc_message_service_info
                @proc_message_service_info ||= described_class.send(:new).send(:servactory_service_info)
              end
            end
          end
        end
      end
    end
  end
end
