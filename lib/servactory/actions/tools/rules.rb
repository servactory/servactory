# frozen_string_literal: true

module Servactory
  module Actions
    module Tools
      class Rules
        RESERVED_METHOD_NAMES = %i[
          inputs
          internals
          outputs
          success!
          fail_input!
          fail_internal!
          fail_output!
          fail!
          fail_result!
        ].freeze
        private_constant :RESERVED_METHOD_NAMES

        def self.check!(...)
          new(...).check!
        end

        def initialize(context)
          @context = context
        end

        def check!
          check_public_methods!
          check_protected_methods!
          check_private_methods!
        end

        private

        def check_public_methods!
          check_in!(@context.public_methods(false))
        end

        def check_protected_methods!
          check_in!(@context.protected_methods(false))
        end

        def check_private_methods!
          check_in!(@context.private_methods(false))
        end

        def check_in!(list_of_methods)
          found_reserved_names = RESERVED_METHOD_NAMES & list_of_methods

          return if found_reserved_names.empty?

          formatted_text = found_reserved_names.map { |method_name| "`#{method_name}`" }.join(", ")

          raise_message_with!(formatted_text)
        end

        def raise_message_with!(formatted_text)
          raise @context.class.config.failure_class.new(
            type: :base,
            message: @context.send(:servactory_service_info).translate(
              "methods.cannot_be_overwritten",
              list_of_methods: formatted_text
            )
          )
        end
      end
    end
  end
end
