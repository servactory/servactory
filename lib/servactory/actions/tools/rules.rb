# frozen_string_literal: true

module Servactory
  module Actions
    module Tools
      class Rules
        RESERVED_METHOD_NAMES = %i[
          success!
          fail!
          fail_input!
          fail_internal!
          fail_output!
          fail_result!
        ].freeze

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
          method_names = RESERVED_METHOD_NAMES & list_of_methods

          return if method_names.empty?

          formatted_text = method_names.map { |method_name| "`#{method_name}`" }.join(", ")

          raise @context.class.config.failure_class.new(
            type: :base,
            message: I18n.t(
              "servactory.methods.cannot_be_overwritten",
              service_class_name: @context.class.name,
              list_of_methods: formatted_text
            )
          )
        end
      end
    end
  end
end
