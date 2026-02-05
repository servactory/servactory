# frozen_string_literal: true

module Servactory
  module Maintenance
    module Attributes
      # @deprecated Use {Servactory::Maintenance::Options::Helper} instead.
      #   This class is maintained for backward compatibility only and will be
      #   removed in a future major version.
      #
      # OptionHelper provides a simple way to define custom option helpers
      # for service inputs, internals, and outputs configuration.
      #
      # @example Creating a custom option helper
      #   Servactory::Maintenance::Attributes::OptionHelper.new(
      #     name: :must_be_positive,
      #     equivalent: {
      #       must: {
      #         be_positive: {
      #           is: ->(value:, **) { value.positive? },
      #           message: "must be positive"
      #         }
      #       }
      #     }
      #   )
      #
      # @see Servactory::Maintenance::Options::Helper The new preferred class
      class OptionHelper < Servactory::Maintenance::Options::Helper
        # @deprecated This class is deprecated. Use Options::Helper instead.
        #
        # Creates a new OptionHelper instance.
        #
        # @param name [Symbol] The name of the option helper
        # @param equivalent [Hash, Proc] The equivalent option configuration
        # @param meta [Hash] Additional metadata for the helper
        # @return [OptionHelper] A new instance
        def initialize(name:, equivalent:, meta: {})
          warn "[DEPRECATION] Servactory::Maintenance::Attributes::OptionHelper is deprecated. " \
               "Use Servactory::Maintenance::Options::Helper instead."
          super
        end
      end
    end
  end
end
