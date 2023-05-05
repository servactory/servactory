# frozen_string_literal: true

module Servactory
  module OutputArguments
    class OutputArgument
      attr_reader :name,
                  :types,
                  :required,
                  :default

      def initialize(name, type:, **options)
        @name = name
        @types = Array(type)

        @required = options.fetch(:required, true)
        @default = required? ? nil : options.fetch(:default, nil)
      end

      def options_for_checks
        {
          types: types,
          required: required,
          default: default
        }
      end

      def required?
        Servactory::Utils.boolean?(required)
      end

      def optional?
        !required?
      end

      def default_value_present?
        !default.nil?
      end
    end
  end
end
