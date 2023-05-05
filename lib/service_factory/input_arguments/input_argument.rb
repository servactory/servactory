# frozen_string_literal: true

module ServiceFactory
  module InputArguments
    class InputArgument
      attr_reader :name,
                  :types,
                  :inclusion,
                  :must,
                  :array,
                  :required,
                  :internal,
                  :default

      def initialize(name, type:, **options)
        @name = name
        @types = Array(type)

        @inclusion = options.fetch(:inclusion, nil)
        @must = options.fetch(:must, nil)
        @array = options.fetch(:array, false)
        @required = options.fetch(:required, true)
        @internal = options.fetch(:internal, false)
        @default = options.fetch(:default, nil)
      end

      def options_for_checks
        {
          types:,
          inclusion:,
          must:,
          required:,
          # internal:,
          default:
        }
      end

      def conflict_code
        return :required_vs_default if required? && default_value_present?
        return :array_vs_array if array? && types.include?(Array)
        return :array_vs_inclusion if array? && inclusion_present?

        nil
      end

      def inclusion_present?
        inclusion.is_a?(Array) && inclusion.present?
      end

      def must_present?
        must.present?
      end

      def array?
        ServiceFactory::Utils.boolean?(array)
      end

      def required?
        ServiceFactory::Utils.boolean?(required)
      end

      def optional?
        !required?
      end

      def internal?
        ServiceFactory::Utils.boolean?(internal)
      end

      def default_value_present?
        !default.nil?
      end

      def with_conflicts?
        conflict_code.present?
      end
    end
  end
end
