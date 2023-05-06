# frozen_string_literal: true

module Servactory
  module InputArguments
    class Option
      DEFAULT_VALUE = ->(is:, message: nil) { { is: is, message: message } }

      private_constant :DEFAULT_VALUE

      attr_reader :name,
                  :check_class,
                  :value

      def initialize(name, check_class:, value_fallback:, with_advanced_mode: true, **options)
        @name = name.to_sym
        @check_class = check_class

        @value = prepare_value_for(options, value_fallback:, with_advanced_mode:)
      end

      private

      def prepare_value_for(options, value_fallback:, with_advanced_mode:)
        return options.fetch(@name, value_fallback) unless with_advanced_mode

        prepare_advanced_for(
          options.fetch(@name, DEFAULT_VALUE.call(is: value_fallback)),
          value_fallback: value_fallback
        )
      end

      def prepare_advanced_for(value, value_fallback)
        if value.is_a?(Hash)
          DEFAULT_VALUE.call(
            is: value.fetch(:is, value_fallback),
            message: value.fetch(:message, nil)
          )
        else
          DEFAULT_VALUE.call(is: value)
        end
      end
    end
  end
end
